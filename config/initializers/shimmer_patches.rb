# frozen_string_literal: true

module Shimmer::FileAdditionsExtensions
  def image_tag(source, **options)
    return nil if source.blank?

    if source.is_a?(ActiveStorage::Variant) || source.is_a?(ActiveStorage::Attached) || source.is_a?(ActiveStorage::Attachment) || source.is_a?(ActionText::Attachment)
      attachment = source
      width = options[:width]
      height = options[:height]
      quality = options[:quality]

      options[:loading] ||= :lazy
      options[:width], options[:height] = calculate_missing_dimensions!(attachment:, width:, height:)

      if options[:loading] == :lazy
        hash_value, primary_color = preview_values(attachment)
        if hash_value.present?
          options.merge!({
            "data-controller": "thumb-hash",
            "data-thumb-hash-preview-hash-value": hash_value
          })
        end
        if primary_color.present?
          options.merge!({
            style: "background-color: ##{primary_color}; background-size: cover;"
          })
        end
      end

      source = image_file_path(source, width:, height:, quality:)

      if options[:width].present?
        width = width.to_i * 2
        height = height ? options[:height].to_i * 2 : nil
        options[:srcset] = "#{source} 1x, #{image_file_path(attachment, width:, height:, quality:)} 2x"
      end
    end
    super source, **options
  end

  private

  def calculate_missing_dimensions!(attachment:, width:, height:)
    return [width, height] if width && height

    original_width = attachment.blob.metadata["width"]&.to_f
    original_height = attachment.blob.metadata["height"]&.to_f

    return [width, height] unless original_width && original_height

    aspect_ratio = original_width / original_height

    if width.nil? && height.nil?
      [original_width.round, original_height.round]
    elsif width.nil?
      [nil, (height.to_i * aspect_ratio).round]
    elsif height.nil?
      [width, (width.to_i / aspect_ratio).round]
    else
      [width, height]
    end
  end

  def preview_values(attachment, quality: nil)
    if attachment.blob.metadata["preview_hash"] && attachment.blob.metadata["primary_color"]
      return [attachment.blob.metadata["preview_hash"], attachment.blob.metadata["primary_color"]]
    end

    CreateImagePreviewJob.perform_later(attachment.id, quality:)
    ["", ""]
  end

  def image_file_path(source, width: nil, height: nil, quality: nil)
    image_file_proxy(source, width:, height:, return_type: :path)
  end

  def image_file_url(source, width: nil, height: nil, quality: nil)
    image_file_proxy(source, width:, height:, return_type: :url)
  end

  def image_file_proxy(source, width: nil, height: nil, return_type: nil, quality: nil)
    return if source.blank?
    return source if source.is_a?(String)

    blob = source.try(:blob) || source
    proxy = Shimmer::FileProxy.new(blob_id: blob.id, width:, height:, quality:)
    case return_type
    when nil
      proxy
    when :path
      proxy.path
    when :url
      proxy.url
    end
  end
end

module Shimmer::FileProxyExtensions
  attr_reader :quality

  def initialize(blob_id:, resize: nil, width: nil, height: nil, quality: nil)
    @blob_id = blob_id
    if !resize && width
      resize = if height
        [width, height]
      else
        [width, nil]
      end
    end
    @resize = resize
    @quality = quality
  end

  def variant
    resize_array = process_resize(resize)

    transformation_options = {resize_to_limit: resize_array, format: :webp}
    transformation_options[:quality] = quality if quality

    Rails.logger.info "Transformation options: #{transformation_options.inspect} for #{blob.id} with resize: #{resize.inspect} and quality: #{quality.inspect}"

    @variant ||= resizeable ? blob.representation(transformation_options).processed : blob
  end

  def variant_content_type
    resizeable ? "image/webp" : content_type
  end

  def variant_filename
    resizeable ? "#{filename.base}.webp" : filename.to_s
  end

  def path
    Rails.application.routes.url_helpers.file_path("#{id}.#{file_extension}", locale: nil)
  end

  def url(protocol: Rails.env.production? ? :https : :http)
    Rails.application.routes.url_helpers.file_url("#{id}.#{file_extension}", locale: nil, protocol:)
  end

  private

  def process_resize(resize)
    return nil unless resize

    if resize.is_a?(String)
      # Split the string and convert to integers. If height is missing, it will be nil
      dimensions = resize.split("x").map { |dim| dim.empty? ? nil : dim.to_i }
      (dimensions.length == 1) ? [dimensions.first, nil] : dimensions
    elsif resize.is_a?(Array)
      resize
    end
  end

  def id
    @id ||= message_verifier.generate([blob_id, resize, quality])
  end

  def file_extension
    File.extname(variant_filename).from(1)
  end
end

Shimmer::FileProxy.prepend(Shimmer::FileProxyExtensions)
Shimmer::FileAdditions.prepend(Shimmer::FileAdditionsExtensions)

module Shimmer
  class FilesController < ActionController::Base
    def show
      expires_in 1.year, public: true
      request.session_options[:skip] = true
      proxy = FileProxy.restore(params.require(:id))

      send_data proxy.file,
        filename: proxy.variant_filename,
        type: proxy.variant_content_type,
        disposition: "inline"
    rescue ActiveRecord::RecordNotFound, ActiveStorage::FileNotFoundError
      head :not_found
    end
  end
end
