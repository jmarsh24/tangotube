# frozen_string_literal: true

class VideosController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :share, :filters, :sort]
  before_action :current_search, only: [:index]
  before_action :check_for_clear, only: [:index]
  before_action :set_video, except: [:index, :create, :destroy]
  before_action :set_video, only: [:show, :hide, :featured, :like, :unlike, :share]

  # @route GET /videos (videos)
  # @route GET / (root)
  def index
    @filtering_params = filtering_params
    @sort_param = params[:sort]
    @search = Video::Search.new(filtering_params:, sort: params[:sort], user: current_user)

    @current_page = params[:page]&.to_i || 1

    @featured_videos = if filtering_params.empty? && params[:sort]&.blank?
      paginated(@search.featured_videos.includes(Video.search_includes), per: 12)
    end

    @videos = if @featured_videos.present?
      paginated(@search.videos.not_featured.includes(Video.search_includes), per: 12)
    else
      paginated(@search.videos.includes(Video.search_includes), per: 12)
    end

    if params[:filtering] == "true" && params[:pagination].nil?
      ui.replace "filter-bar", with: "videos/index/video_sorting_filters", filtering_params:
      ui.close_modal
      new_params = @filtering_params.to_h
      new_params[:sort] = @sort_param if @sort_param.present?
      new_params.except(:filtering, :pagination)
      url = url_for(new_params)
      ui.run_javascript "history.pushState(history.state, '', '#{url}');"
    end
  end

  # @route GET /videos/:id (video)
  # @route GET /watch (watch)
  def show
    if @video.nil?
      ExternalVideoImport::Importer.new.import(params[:v], use_scraper: false)
      @video = Video.find_by(youtube_id: params[:v])
    end

    @related_videos = Video::RelatedVideos.new(@video)
    @start_value = params[:start]
    @end_value = params[:end]
    @root_url = root_url
    @playback_rate = params[:speed] || "1"

    @video.clicked!

    current_user&.watches&.create(video: @video, watched_at: Time.now)
  end

  # @route POST /videos/:id/hide (hide_video)
  def hide
    @video.hidden = true
    @video.save
    render turbo_stream: turbo_stream.remove("video_#{@video.youtube_id}")
  end

  # @route PATCH /videos/:id/featured (featured_video)
  def featured
    @video.update!(featured: !@video.featured?)
    ui.update("video_#{@video.id}_vote", with: "videos/show/vote", video: @video)
  end

  # POST /videos/:id/like
  def like
    authorize @video
    current_user.likes.create!(likeable: @video)
    ui.update("video_#{@video.id}_vote", with: "videos/show/vote", video: @video)
  end

  # DELETE /videos/:id/unlike
  def unlike
    authorize @video
    like = current_user.likes.find_by(likeable: @video)
    like&.destroy!
    ui.update("video_#{@video.id}_vote", with: "videos/show/vote", video: @video)
  end

  def filters
  end

  def share
  end

  def sort
    @filtering_params = filtering_params
  end

  private

  def check_for_clear
    if params[:commit] == "Clear"
      redirect_to root_path
    end
  end

  def set_video
    @video = Video.find_by(youtube_id: params[:v]) || Video.find_by(youtube_id: params[:id])
  end

  def fetch_video_if_nil
    return unless @video.nil?

    ExternalVideoImport::Importer.new.import(params[:v])
    @video = Video.find_by(youtube_id: params[:v])
  end

  def current_search
    @current_search = params[:search]
  end

  def filtering_params
    params.permit(
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
      :couples
    )
  end
end
