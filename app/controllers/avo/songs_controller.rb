# frozen_string_literal: true

# This controller has been generated to enable Rails' resource routes.
# More information on https://docs.avohq.io/2.0/controllers.html
class Avo::SongsController < Avo::ResourcesController
  def update_success_action
    videos = resource.model.videos
    videos.update_all(song_id: nil)
    videos.each do |video|
      UpdateVideoJob.perform_later(video)
    end
    super
  end
end
