# frozen_string_literal: true

class RefreshVideoSearchesViewJob < ApplicationJob
  queue_as :low_priority

  def perform
    VideoSearch.refresh
  end
end
