# frozen_string_literal: true

# class CreateImagePreviewJob < ActiveJob::Base
#   queue_as :active_storage_analysis

#   def perform(attachment_id, quality: nil)
#     attachment = ActiveStorage::Attachment.find(attachment_id)

#     preview = attachment.variant(resize_to_limit: [100, 100], format: :webp, quality:).processed

#     image = Vips::Image.new_from_buffer(preview.download, "")

#     attachment.blob.metadata.merge!({
#       preview_hash: preview_hash(image),
#       primary_color: average_color_from_image(image)
#     })

#     attachment.blob.save!
#   rescue ActiveStorage::FileNotFoundError => e
#     Rails.logger.error("ActiveStorage::FileNotFoundError: #{e.message}")
#   end

#   private

#   def preview_hash(image)
#     if image.bands == 3
#       image = image.bandjoin(255)
#     end

#     flattened_pixels = image.write_to_memory.unpack("C*")

#     ThumbHash.rgba_to_thumb_hash(
#       image.width,
#       image.height,
#       flattened_pixels
#     ).unpack1("H*")
#   end

#   def average_color_from_image(image)
#     red_band = image[0].avg
#     green_band = image[1].avg
#     blue_band = image[2].avg

#     [red_band, green_band, blue_band].map(&:to_i).map { |value| value.to_s(16).rjust(2, "0") }.join.upcase
#   end
# end
