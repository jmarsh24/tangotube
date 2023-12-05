# frozen_string_literal: true

class WatchesController < ApplicationController
  # @route GET /watch (watch)
  def show
    if params[:v].blank?
      redirect_to root_path and return
    end

    @video = Video.find_by(youtube_id: params[:v]) || Import::Importer.new.import(params[:v])

    if @video
      UpdateVideoJob.perform_later(@video, use_music_recognizer: !@video.music_scanned?) if @video.updated_at < 1.week.ago
      @type = Video::RelatedVideos.new(@video).available_types.first
      @playback_options = Watch::PlaybackOptions.new(
        start_time: params[:start],
        end_time: params[:end],
        speed: params[:speed] || "1"
      )
      current_user&.watches&.create!(video: @video, watched_at: Time.now)
    else
      flash[:error] = "Video not found"
      redirect_to root_path and return
    end
  end
end
