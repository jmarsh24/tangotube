# frozen_string_literal: true

module Shimmer::FileAdditionsExtensions
  def image_tag(source, **options)
    return nil if source.blank?

    if source.is_a?(ActiveStorage::Variant) || source.is_a?(ActiveStorage::Attached) || source.is_a?(ActiveStorage::Attachment) || source.is_a?(ActionText::Attachment)
      attachment = source
      width = options[:width]
      height = options[:height]

      source = image_file_path(source, width:, height:)
      options[:loading] ||= :lazy
      if options[:loading] == :lazy
        options["data-controller"] = "thumb-hash"
        options[:style] = "background-color: ##{preview_primary_color(attachment)}; background-size: cover;"
        options["data-thumb-hash-preview-hash-value"] = preview_hash(attachment)
      end
      options[:srcset] = "#{source} 1x, #{image_file_path(attachment, width: width.to_i * 2, height: height ? height.to_i * 2 : nil)} 2x" if options[:width].present?
    end
    super source, **options
  end

  def preview_hash(attachment)
    if attachment.blob.preview_hash
      attachment.blob.preview_hash
    else
      CreateImagePreviewJob.perform_later(attachment.id)
      ""
    end
  end

  def preview_primary_color(attachment)
    attachment.blob.primary_color || CreateImagePreviewJob.perform_later(attachment.id)
  end
end

Shimmer::FileAdditions.prepend(Shimmer::FileAdditionsExtensions)

module Shimmer::FileProxyExtensions
  def variant
    transformations = resizeable ? {resize:, format: "webp"} : {format: "webp"}
    @variant ||= blob.representation(transformations).processed
  end
end

Shimmer::FileProxy.prepend(Shimmer::FileProxyExtensions)
