# frozen_string_literal: true

# This controller has been generated to enable Rails' resource routes.
# More information on https://docs.avohq.io/2.0/controllers.html
class Avo::SongsController < Avo::ResourcesController
  def update_success_action
    song = resource.model
    unless song.active?
      song_videos = song.videos
      song_videos.update_all(song_id: nil)
      song_videos.each do |video|
        UpdateVideoJob.perform_later(video)
      end
    end
    super
  end
end
