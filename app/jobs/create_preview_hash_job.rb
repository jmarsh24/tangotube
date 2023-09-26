# frozen_string_literal: true

class CreatePreviewHashJob < ApplicationJob
  queue_as :active_storage_analysis
  sidekiq_options retry: false

  def perform(attachment)
    return unless attachment

    preview = attachment.variant(resize: "10x10").processed
    preview_hash = Base64.encode64(preview.download)

    attachment.blob.update(preview_hash:)
  end
end
