# frozen_string_literal: true

class VideosController < ApplicationController
  before_action :check_for_clear, only: [:index]
  before_action :set_video, only: [:share, :details, :process_metadata, :hide]
  helper_method :filtering_params

  # @route GET /videos (videos)
  # @route GET / (root)
  def index
    @filtering_params = filtering_params
    @sort_param = params[:sort]
    @search = Video::Search.new(filtering_params:, sort: params[:sort], user: current_user)
    @show_filter_bar = true

    @videos = paginated(@search.videos.has_dancer.not_hidden.from_active_channels.preload(Video.search_includes).load_async, per: 24)
    respond_to do |format|
      format.html
      format.turbo_stream do
        if params[:filtering] == "true" && params[:pagination].nil?
          ui.update "videos", with: "videos/videos", videos: @videos
          ui.replace "filter-bar", with: "videos/index/video_sorting_filters", filtering_params:
          ui.close_modal
          ui.run_javascript("history.pushState(history.state, '', '#{url_for(params.to_h.except(:filtering, :pagination))}');")
        end
      end
    end
  end

  # @route GET /videos/filters (filters_videos)
  def filters
  end

  # @route GET /videos/:id/share (share_video)
  def share
  end

  # @route GET /videos/sort (sort_videos)
  def sort
    @filtering_params = filtering_params
  end

  # @route GET /videos/:id/details (details_video)
  def details
  end

  # @route POST /videos/:id/hide (hide_video)
  def hide
    @video.update(hidden: true)
    redirect_to root_path
  end

  # @route POST /videos/:id/process_metadata (process_metadata_video)
  def process_metadata
    if !(@video.acr_response_code == 0 || @video.acr_response_code == 1001)
      UpdateWithMusicRecognizerVideoJob.perform_later(@video)
    else
      UpdateVideoJob.perform_later(@video)
    end
    head :ok
  end

  private

  def is_bot?
    browser = Browser.new(request.user_agent)
    browser.bot?
  end

  def check_for_clear
    if params[:commit] == "Clear"
      redirect_to root_path
    end
  end

  def set_video
    @video = Video.includes(:channel).find_by(youtube_id: params[:v] || params[:id])
  end

  def filtering_params
    params.permit!.slice(
      :leader,
      :follower,
      :channel,
      :genre,
      :orchestra,
      :song,
      :hd,
      :event,
      :year,
      :watched,
      :liked,
      :search,
      :dancer,
      :couple,
      :category
    ).to_h
  end
end
