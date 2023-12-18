# frozen_string_literal: true

class RelatedVideosController < ApplicationController
  # @route GET /related_videos/:id (related_video)
  def show
    @video = Video.includes(:leaders, :followers, :performance, :song, :channel, :event, :dancer_videos, :dancers).find(params[:id])
    related_videos = Video::RelatedVideos.new(@video)
    @type = params[:type] || related_videos.available_types.first

    related_videos = case params[:type]
    when "same_dancers"
      related_videos.with_same_dancers
    when "same_event"
      related_videos.with_same_event
    when "same_song"
      related_videos.with_same_song
    when "same_channel"
      related_videos.with_same_channel
    when "same_performance"
      related_videos.with_same_performance
    else
      Video.none
    end
    @related_videos = related_videos.preload(Video.search_includes).limit(8)
    ui.replace "related-videos-links", with: "links", video: @video, type: @type
    ui.replace "related-videos", with: "videos", videos: @related_videos, type: @type, video: @video
  end
end
