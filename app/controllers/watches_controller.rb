# frozen_string_literal: true

class WatchesController < ApplicationController
  # @route GET /videos/:id (video)
  # @route GET /watch (watch)
  def show
    redirect_to root_path unless params[:v].present?

    if @video.nil?
      ExternalVideoImport::Importer.new.import(params[:v])
      @video = Video.preload(dancer_videos: :dancer).find_by(youtube_id: params[:v])
    end

    @type = Video::RelatedVideos.new(@video).available_types.first

    @start_value = params[:start]
    @end_value = params[:end]
    @root_url = root_url
    @playback_rate = params[:speed] || "1"

    current_user&.watches&.create!(video: @video, watched_at: Time.now) unless is_bot?
  end

  private

  def is_bot?
    browser = Browser.new(request.user_agent)
    browser.bot?
  end
end
