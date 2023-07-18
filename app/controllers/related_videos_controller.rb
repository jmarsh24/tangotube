# frozen_string_literal: true

class RelatedVideosController < ApplicationController
  def show
    @video = Video.find(params[:id])
    related_videos_service = Video::RelatedVideos.new(@video)
    @type = params[:type]
    @header = t(".header_#{params[:type]}")
    related_videos = case params[:type]

    when "same_dancers"
      related_videos_service.with_same_dancers
    when "same_event"
      related_videos_service.with_same_event
    when "same_song"
      related_videos_service.with_same_song
    when "same_channel"
      related_videos_service.with_same_channel
    when "same_performance"
      related_videos_service.with_same_performance
    end
    @related_videos = related_videos ? related_videos.includes(:channel, :song, dancer_videos: :dancer, thumbnail_attachment: :blob).limit(8) : []
  end
end
