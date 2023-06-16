# frozen_string_literal: true

class VideosController < ApplicationController
  before_action :authenticate_user!, only: [:upvote, :downvote, :bookmark, :complete, :watchlist]
  before_action :authorize_admin!, only: [:featured]
  before_action :current_search, only: [:index]
  before_action :check_for_clear, only: [:index]
  before_action :set_video, except: [:index, :create, :destroy]
  helper_method :filtering_params, :sorting_params

  # @route GET /videos (videos)
  # @route POST /
  # @route GET / (root)
  def index
    @search = Video::Search.new(filtering_params:, sorting_params:, user: current_user)

    @current_page = params[:page]&.to_i || 1

    @featured_videos = (filtering_params.empty? && sorting_params.empty?) ? paginated(@search.featured_videos, per: 12) : nil

    @videos = @featured_videos.present? ? paginated(@search.videos.not_featured, per: 12) : paginated(@search.videos, per: 12)

    handle_filtering_and_pagination if params[:filtering] == "true" && params[:pagination].nil? && filtering_params.present?
  end

  # @route GET /videos/:id (video)
  # @route GET /watch (watch)
  def show
    if @video.nil?
      ExternalVideoImport::Importer.new.import(video_params[:v], use_scraper: false)
      @video = Video.find_by(youtube_id: video_params[:v])
    end

    @related_videos = Video::RelatedVideos.new(@video)

    @video.clicked!

    current_user&.watches&.create(video: @video, watched_at: Time.now)
  end

  # @route GET /videos/:id/edit (edit_video)
  def edit
  end

  # @route PATCH /videos/:id (video)
  # @route PUT /videos/:id (video)
  def update
    authorize @video

    respond_to do |format|
      if @video.update(video_params)
        format.turbo_stream { render "videos/show", video: @video }
        format.html { render partial: "videos/show/video_info_details", video: @video }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # @route DELETE /videos/:id (video)
  def destroy
    authorize @video
    @video.destroy
    redirect_to root_path
  end

  # @route POST /videos/:id/hide (hide_video)
  def hide
    @video.hidden = true
    @video.save
    render turbo_stream: turbo_stream.remove("video_#{@video.youtube_id}")
  end

  # @route PATCH /videos/:id/upvote (upvote_video)
  def upvote
    update_upvote "like"
  end

  # @route PATCH /videos/:id/downvote (downvote_video)
  def downvote
    update_downvote "like"
  end

  # @route PATCH /videos/:id/featured (featured_video)
  def featured
    @video.update!(featured: !@video.featured?)
    ui.update("video_#{@video.id}_vote", with: "videos/show/vote")
  end

  private

  def handle_filtering_and_pagination(video_search)
    url = request.fullpath.gsub(/&?(filtering|pagination)=true/, "")
    replace_filters_bar(url)
    update_video_list(video_search, url)
    append_pagination(video_search, url) if @current_page > 1 && video_params[:pagination] == "true"
  end

  def update_video_list(video_search, url)
    @videos = video_search.paginated_videos(@current_page, per_page: 12)
    ui.replace "videos", with: "videos/videos", items: @videos, partial: params[:partial]
    ui.remove "next-page-link" if @current_page > 1 && video_params[:pagination] == "true"
  end

  def append_pagination(video_search, url)
    next_page = video_search.next_page(@videos)
    ui.append "pagination-frame", with: "components/pagination", items: @videos, partial: params[:partial], next_page:
  end

  def authorize_admin!
    authorize :admin, :access?
  end

  def check_for_clear
    if video_params[:commit] == "Clear"
      redirect_to root_path
    end
  end

  def set_video
    @video = Video.find_by(youtube_id: video_params[:v]) if video_params[:v]
  end

  def fetch_video_if_nil
    return unless @video.nil?

    ExternalVideoImport::Importer.new.import(video_params[:v])
    @video = Video.find_by(youtube_id: video_params[:v])
  end

  def current_search
    @current_search = video_params[:query]
  end

  def video_params
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
      :id,
      :query,
      :dancer,
      :couples,
      :page,
      :direction,
      :sort,
      :leader_id,
      :follower_id,
      :song_id,
      :event_id,
      :hidden,
      :"performance_date(1i)",
      :"performance_date(2i)",
      :"performance_date(3i)",
      :performance_number,
      :performance_total_number,
      :id,
      :v,
      :video_id,
      :filtering,
      :pagination
    )
  end

  def filtering_params
    video_params.slice(
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
      :id,
      :song_id,
      :event_id,
      :query,
      :dancer,
      :couples
    )
  end

  def sorting_params
    video_params.slice(
      :direction,
      :sort
    )
  end

  def update_upvote(scope)
    if current_user.voted_up_on? @video, vote_scope: scope
      @video.unvote_by current_user, vote_scope: scope
    else
      @video.upvote_by current_user, vote_scope: scope
    end
    ui.update("video_#{@video.id}_vote", with: "videos/show/vote")
  end

  def update_downvote(scope)
    if current_user.voted_down_on? @video, vote_scope: scope
      @video.unvote_by current_user, vote_scope: scope
    else
      @video.downvote_by current_user, vote_scope: scope
    end
    ui.update("video_#{@video.id}_vote", with: "videos/show/vote")
  end
end
