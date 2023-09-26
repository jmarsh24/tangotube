# frozen_string_literal: true

class CreateImagePreviewJob < ApplicationJob
  queue_as :active_storage_analysis
  sidekiq_options retry: false

  def perform(attachment_id)
    attachment = ActiveStorage::Attachment.find(attachment_id)

    return unless attachment

    preview = attachment.variant(resize_to_limit: [100, 100]).processed

    image = Vips::Image.new_from_buffer(preview.download, "")

    attachment.blob.update!(preview_hash: preview_hash(image), primary_color: average_color_from_image(image))
  end

  private

  def preview_hash(image)
    if image.bands == 3
      image = image.bandjoin(255)
    end

    flattened_pixels = image.write_to_memory.unpack("C*")

    ThumbHash.rgba_to_thumb_hash(
      image.width,
      image.height,
      flattened_pixels
    ).unpack1("H*")
  end

  def average_color_from_image(image)
    red_band = image[0].avg
    green_band = image[1].avg
    blue_band = image[2].avg

    [red_band, green_band, blue_band].map(&:to_i).map { |value| value.to_s(16).rjust(2, "0") }.join.upcase
  end
end
