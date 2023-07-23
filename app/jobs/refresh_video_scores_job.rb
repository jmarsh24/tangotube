# frozen_string_literal: true

class RefreshVideoScoresJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: false

  def perform
    VideoScore.refresh
  end
end
