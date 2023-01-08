# frozen_string_literal: true

class DestroyVideoJob < ApplicationJob
  queue_as :low_priority

  def perform(youtube_id)
    Video.find_by(youtube_id:).destroy
  end
end
