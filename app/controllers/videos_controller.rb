# frozen_string_literal: true

class VideosController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :current_search, only: [:index]
  before_action :set_video, except: [:index]
  before_action :check_for_clear, only: [:index]
  before_action :authorize_admin!, except: [:index, :show]

  before_action :set_video, except: [:index, :create, :destroy]
  before_action :authorize_admin!, except: [:index, :show, :create, :destroy]

  helper_method :filtering_params, :sorting_params

  # @route GET /videos (videos)
  # @route POST /
  # @route GET / (root)
  def index
    @search = Video::Search.new(filtering_params:, sorting_params:, hidden: false, current_user:)
    @current_page = params[:page]&.to_i || 1
    @videos = paginated(@search.videos.with_attached_thumbnail, per: 12)
    if filtering_params.empty? && sorting_params.empty?
      @featured_videos = paginated(@search.featured_videos.with_attached_thumbnail, per: 12)
    end
    @search_facets = @search.facets

    handle_filtering_and_pagination(@search) if params[:filtering] == "true" && params[:pagination].nil? && filtering_params.present?
  end

  # @route GET /videos/:id (video)
  # @route GET /watch (watch)
  def show
    if @video.nil?
      ExternalVideoImport::Importer.new.import(video_params[:v])
      @video = Video.find_by(youtube_id: video_params[:v])
    end
    set_recommended_videos
    @start_value = params[:start]
    @end_value = params[:end]
    @root_url = root_url
    @playback_rate = params[:speed] || "1"
    @clip = Clip.new

    @comments =
      if params[:comment]
        @video.comments.includes([:commentable]).where(id: params[:comment])
      else
        @video.comments.includes([:commentable]).where(parent_id: nil)
      end

    @video.clicked!

    if user_signed_in?
      MarkVideoAsWatchedJob.perform_later(video_params[:v], current_user.id)
    end
  end

  # @route GET /videos/:id/edit (edit_video)
  def edit
    @clip = Clip.new
    set_recommended_videos
  end

  # @route POST /videos (videos)
  def create
    authorize Video
    @video = Video.create(youtube_id: params[:video][:youtube_id])
    fetch_new_video

    redirect_to root_path
  end

  # @route PATCH /videos/:id (video)
  # @route PUT /videos/:id (video)
  def update
    authorize @video
    @clip = Clip.new

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

  # @route PATCH /videos/:id/bookmark (bookmark_video)
  def bookmark
    update_upvote "bookmark"
  end

  # @route PATCH /videos/:id/complete (complete_video)
  def complete
    update_upvote "watchlist"
  end

  # @route PATCH /videos/:id/watchlist (watchlist_video)
  def watchlist
    update_downvote "watchlist"
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
    @video = Video.includes(Video.search_includes).find_by(youtube_id: video_params[:v]) if video_params[:v]
    @video = Video.includes(Video.search_includes).find_by(youtube_id: video_params[:id]) if video_params[:id]
    @video = Video.find_by(youtube_id: video_params[:video_id]) if video_params[:video_id]
  end

  def fetch_video_if_nil
    return unless @video.nil?

    ExternalVideoImport::Importer.new.import(video_params[:v])
    @video = Video.find_by(youtube_id: video_params[:v])
  end

  def set_recommended_videos
    related_videos = Video::RelatedVideos.new(@video)

    @videos_from_this_performance = related_videos.with_same_performance.limit(8).includes(:thumbnail_attachment)
    @videos_with_same_dancers = related_videos.with_same_dancers.limit(8).includes(:thumbnail_attachment)
    @videos_with_same_event = (related_videos.with_same_event.limit(16).includes(:thumbnail_attachment) - related_videos.with_same_performance.limit(16).includes(:thumbnail_attachment))
    @videos_with_same_song = related_videos.with_same_song.limit(8).includes(:thumbnail_attachment)
    @videos_with_same_channel = related_videos.with_same_channel.limit(8).includes(:thumbnail_attachment)
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
    video_params.permit(
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

  def page
    video_params[:page]
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
