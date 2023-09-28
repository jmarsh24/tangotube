# frozen_string_literal: true

module Shimmer::FileAdditionsExtensions
  def image_tag(source, **options)
    return nil if source.blank?

    if source.is_a?(ActiveStorage::Variant) || source.is_a?(ActiveStorage::Attached) || source.is_a?(ActiveStorage::Attachment) || source.is_a?(ActionText::Attachment)
      raise ArgumentError, "The 'alt' attribute is required for image_tag" if options[:alt].blank?
      raise ArgumentError, "Either width or height is required for image_tag" if options[:width].blank? && options[:height].blank?

      attachment = source
      width = options[:width]
      height = options[:height]
      options[:loading] ||= :lazy

      width, height = calculate_missing_dimensions!(attachment:, width:, height:)

      options[:width] = width
      options[:height] = height

      if options[:loading] == :lazy
        hash_value = preview_hash(attachment)
        primary_color = preview_primary_color(attachment)

        options.merge!({
          "data-controller": "thumb-hash",
          "data-thumb-hash-preview-hash-value": hash_value,
          style: "background-color: ##{primary_color}; background-size: cover;"
        })
      end

      if options[:width].present?
        options[:srcset] = "#{source} 1x, #{image_file_path(attachment, width: width.to_i * 2, height: height ? options[:height].to_i * 2 : nil)} 2x"
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

  def preview_hash(attachment)
    return attachment.blob.preview_hash if attachment.blob.preview_hash

    CreateImagePreviewJob.perform_later(attachment.id)
    ""
  end

  def preview_primary_color(attachment)
    return attachment.blob.primary_color if attachment.blob.primary_color

    CreateImagePreviewJob.perform_later(attachment.id)
    ""
  end
end

Shimmer::FileAdditions.prepend(Shimmer::FileAdditionsExtensions)

module Shimmer::FileProxyExtensions
  def initialize(blob_id:, resize: nil, width: nil, height: nil)
    @blob_id = blob_id
    if !resize && width
      resize = if height
        [width, height]
      else
        [width, nil]
      end
    end
    @resize = resize
  end

  def variant
    @variant ||= resizeable ? blob.representation({resize_to_limit: resize, format: :webp}).processed : blob
  end
end

Shimmer::FileProxy.prepend(Shimmer::FileProxyExtensions)
