# frozen_string_literal: true

module Shimmer::FileAdditionsExtensions
  def image_tag(source, **options)
    return nil if source.blank?

    if source.is_a?(ActiveStorage::Variant) || source.is_a?(ActiveStorage::Attached) || source.is_a?(ActiveStorage::Attachment) || source.is_a?(ActionText::Attachment)
      raise ArgumentError, "The 'alt' attribute is required for image_tag" if options[:alt].blank?
      raise ArgumentError, "Either width or height is required for image_tag" if options[:width].blank? && options[:height].blank?

      attachment = source
      calculate_missing_dimensions!(attachment, options)

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
        options[:srcset] = "#{source} 1x, #{image_file_path(attachment, width: options[:width].to_i * 2, height: options[:height] ? options[:height].to_i * 2 : nil)} 2x"
      end
    end

    super source, **options
  end

  private

  def calculate_missing_dimensions!(attachment, options)
    return unless attachment.blob.metadata["width"] && attachment.blob.metadata["height"]

    original_width = attachment.blob.metadata["width"].to_f
    original_height = attachment.blob.metadata["height"].to_f
    aspect_ratio = original_width / original_height

    if options[:width].present? && options[:height].blank?
      options[:height] = (options[:width].to_i / aspect_ratio).round
    elsif options[:height].present? && options[:width].blank?
      options[:width] = (options[:height].to_i * aspect_ratio).round
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
