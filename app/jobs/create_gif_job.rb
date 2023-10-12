# frozen_string_literal: true

class CreateGifJob < ApplicationJob
  queue_as :low_priority

  def perform(clip_id)
    Clip.find(clip_id).create_gif
  end
end
