# frozen_string_literal: true

class RelatedVideosController < ApplicationController
  def show
    @video = Video.find(params[:id])
    related_videos = Video::RelatedVideos.new(@video)
    @type = params[:type]

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
        ui.replace "related-video-links", with: "links", video: @video
        ui.append "related-videos", with: "videos", videos: @related_videos, type: @type, video: @video
      end
      format.html
    end
  end
end
