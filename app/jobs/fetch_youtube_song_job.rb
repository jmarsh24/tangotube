# frozen_string_literal: true

class FetchYoutubeSongJob < ApplicationJob
  queue_as :low_priority

  def perform(youtube_id)
    Video::YoutubeDlImport.from_video(youtube_id)
  end
end
