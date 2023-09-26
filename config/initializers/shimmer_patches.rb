# frozen_string_literal: true

module Shimmer::FileAdditionsExtensions
  def image_tag(source, **options)
    return nil if source.blank?

    if source.is_a?(ActiveStorage::Variant) || source.is_a?(ActiveStorage::Attached) || source.is_a?(ActiveStorage::Attachment) || source.is_a?(ActionText::Attachment)
      attachment = source
      width = options[:width]
      height = options[:height]
      options[:style] = "background-image: url(#{preview_data_url(attachment)}); background-size: cover;" + (options[:style] || "")
      source = image_file_path(source, width:, height:)
      options[:loading] ||= :lazy
      if options[:loading] == :lazy
        options[:class] = "#{options[:class]} loading".strip
        options["data-controller"] = "image-loading"
        options["data-action"] = "load->image-loading#loaded"
      end
      options[:srcset] = "#{source} 1x, #{image_file_path(attachment, width: width.to_i * 2, height: height ? height.to_i * 2 : nil)} 2x" if options[:width].present?
    end
    super source, **options
  end

  def preview_data_url(attachment, width: 10, height: 10)
    preview = attachment.variant(resize: "#{width}x#{height}").processed
    return unless preview

    if attachment.blob.preview_hash
      "data:image/jpeg;base64,#{attachment.blob.preview_hash}"
    else
      preview_hash = Base64.encode64(preview.download)
      attachment.blob.update(preview_hash:)
      "data:image/jpeg;base64,#{preview_hash}"
    end
  end
end

Shimmer::FileAdditions.prepend(Shimmer::FileAdditionsExtensions)

module Shimmer::FileProxyExtensions
  def variant
    transformations = resizeable ? {resize:, format: "webp"} : {format: "webp"}
    @variant ||= blob.representation(transformations).processed
  end

  def preview_variant
    transformations = {resize: "10x10", format: "webp"}
    blob.representation(transformations).processed
  end
end

Shimmer::FileProxy.prepend(Shimmer::FileProxyExtensions)
