# frozen_string_literal: true

class VideosController < ApplicationController
  before_action :check_for_clear, only: [:index]
  before_action :set_video, only: [:share, :details, :process_metadata, :hide]

  # @route GET /videos (videos)
  # @route GET / (root)
  def index
    @filtering_params = filtering_params
    @sort_param = params[:sort]
    @search = Video::Search.new(filtering_params:, sort: params[:sort], user: current_user)
    @show_filter_bar = true

    @videos = paginated(@search.videos.not_hidden.from_active_channels.preload(Video.search_includes), per: 24)

    if params[:filtering] == "true" && params[:pagination].nil?
      ui.update "videos", with: "videos/videos", items: @videos
      ui.replace "filter-bar", with: "videos/index/video_sorting_filters", filtering_params:
      ui.run_javascript("history.pushState(history.state, '', '#{url_for(params.to_h.except(:filtering, :pagination))}');")
    end
  end

  # @route GET /videos/:id (video)
  # @route GET /watch (watch)
  def show
    redirect_to root_path unless params[:v].present?

    if @video.nil?
      ExternalVideoImport::Importer.new.import(params[:v])
      @video = Video.preload(dancer_videos: :dancer).find_by(youtube_id: params[:v] || params[:id])
    end

    @type = Video::RelatedVideos.new(@video).available_types.first

    @start_value = params[:start]
    @end_value = params[:end]
    @root_url = root_url
    @playback_rate = params[:speed] || "1"

    current_user&.watches&.create!(video: @video, watched_at: Time.now)
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

  def hide
    @video.update(hidden: true)
    redirect_to root_path
  end

  def process_metadata
    UpdateVideoJob.set(queue: :high_priority).perform_later(@video, use_music_recognizer: true)
    head :ok
  end

  private

  def check_for_clear
    if params[:commit] == "Clear"
      redirect_to root_path
    end
  end

  def set_video
    @video = Video.find_by(youtube_id: params[:v] || params[:id])
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
      :couple
    ).to_h
  end
end
