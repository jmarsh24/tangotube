# frozen_string_literal: true

class RelatedVideosController < ApplicationController
  # @route GET /related_videos/:id (related_video)
  def show
    @video = Video.find(params[:id])
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
    end
    @related_videos = related_videos.includes(:channel, :song, dancer_videos: :dancer, thumbnail_attachment: :blob).limit(8)

    respond_to do |format|
      format.turbo_stream do
        ui.replace "related-videos-links", with: "links", video: @video, type: @type
        ui.replace "related-videos", with: "videos", videos: @related_videos, type: @type, video: @video
      end
      format.html
    end
  end
end
