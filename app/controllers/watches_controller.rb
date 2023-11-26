# frozen_string_literal: true

class WatchesController < ApplicationController
  # @route GET /watch (watch)
  def show
    redirect_to root_path unless params[:v].present?
    @video = Video.find_by(youtube_id: params[:v])

    if @video.nil?
      @video = Import::Importer.new.import(params[:v])
      if @video.present?
        UpdateVideoJob.perform_later(@video, use_music_recognizer: true)
      else
        flash[:error] = "Video not found"
        redirect_to root_path
      end
    else
      @type = Video::RelatedVideos.new(@video).available_types.first

      @playback_options = Watch::PlaybackOptions.new(
        start_time: params[:start],
        end_time: params[:end],
        speed: params[:speed] || "1"
      )
      unless is_bot?
        current_user&.watches&.create!(video: @video, watched_at: Time.now)
      end
    end
  end
end
