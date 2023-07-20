# frozen_string_literal: true

class RefreshVideoScoresJob < ApplicationJob
  queue_as :default

  def perform
    VideoScore.refresh
  end
end
