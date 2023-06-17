# frozen_string_literal: true

class VideosController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :share]
  before_action :current_search, only: [:index]
  before_action :check_for_clear, only: [:index]
  before_action :set_video, except: [:index, :create, :destroy]
  before_action :set_video, only: [:show, :hide, :featured, :like, :unlike, :share]
  helper_method :filtering_params, :sorting_params

  # @route GET /videos (videos)
  # @route GET / (root)
  def index
    @search = Video::Search.new(filtering_params:, sorting_params:, user: current_user)

    @current_page = params[:page]&.to_i || 1

    @featured_videos = if filtering_params.empty? && sorting_params.empty?
      paginated(@search.featured_videos.includes(Video.search_includes), per: 12)
    end

    @videos = if @featured_videos.present?
      paginated(@search.videos.not_featured.includes(Video.search_includes), per: 12)
    else
      paginated(@search.videos.includes(Video.search_includes), per: 12)
    end

    handle_filtering_and_pagination if params[:filtering] == "true" && params[:pagination].nil? && filtering_params.present?
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
    ui.update("video_#{@video.id}_vote", with: "videos/show/vote")
  end

  # POST /videos/:id/like
  def like
    authorize @video
    current_user.likes.create!(likeable: @video)
    ui.update("video_#{@video.id}_vote", with: "videos/show/vote")
  end

  # DELETE /videos/:id/unlike
  def unlike
    authorize @video
    like = current_user.likes.find_by(likeable: @video)
    like&.destroy!
    ui.update("video_#{@video.id}_vote", with: "videos/show/vote")
  end

  def filters
  end

  def share
  end

  private

  def handle_filtering_and_pagination(video_search)
    url = request.fullpath.gsub(/&?(filtering|pagination)=true/, "")
    replace_filters_bar(url)
    update_video_list(video_search, url)
    append_pagination(video_search, url) if @current_page > 1 && params[:pagination] == "true"
  end

  def update_video_list(video_search, url)
    @videos = video_search.paginated_videos(@current_page, per_page: 12)
    ui.replace "videos", with: "videos/videos", items: @videos, partial: params[:partial]
    ui.remove "next-page-link" if @current_page > 1 && params[:pagination] == "true"
  end

  def append_pagination(video_search, url)
    next_page = video_search.next_page(@videos)
    ui.append "pagination-frame", with: "components/pagination", items: @videos, partial: params[:partial], next_page:
  end

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

  def sorting_params
    params.permit(
      :direction,
      :sort
    )
  end
end
