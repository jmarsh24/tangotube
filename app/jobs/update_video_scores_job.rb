# frozen_string_literal: true

class UpdateVideoScoresJob < ApplicationJob
  queue_as :default

  def perform
    VideoScore.update_all_scores
  end
end
