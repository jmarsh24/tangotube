# frozen_string_literal: true

class RefreshVideoSearchesViewJob < ApplicationJob
  queue_as :low_priority
  sidekiq_options retry: false

  def perform
    VideoSearch.refresh
  end
end
