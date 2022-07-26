class VideosController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :authenticate_user!, only: %i[edit update create upvote downvote bookmark watchlist complete featured]
  before_action :current_search, only: %i[index]
  before_action :set_video, only: %i[show edit update destroy hide upvote downvote bookmark watchlist complete featured]
  after_action :track_action

  helper_method :sorting_params, :filtering_params

  def index
    @sort_column = sort_column
    @sort_direction = sort_direction

    filter_array = []

    filters = filtering_params.except(:query, :liked, :watched)

    if sorting_params.present?
      order = { sort_column => sort_direction }
    end

    if user_signed_in?
      user_id = current_user.id
    end

    if filtering_params.include?("watched")
      if filtering_params["watched"] == "true"
        filters.merge!({ watched_by: user_id })
      end
      if filtering_params["watched"] == "false"
        filters.merge!({ not_watched_by: user_id })
      end
    end

    if filtering_params.include?("liked")
      if filtering_params["liked"] == "true"
        filters.merge!({ liked_by: user_id })
      end

      if filtering_params["liked"] == "false"
        filters.merge!({ disliked_by: user_id })
      end
    end

    if filtering_params.except("query").except("watched").except("liked").present?
      filtering_params.except("query").except("watched").except("liked").to_h.map { |k, v| "#{k} = '#{v}'" }.each do |filter|
        filter_array << filter
      end
    end

    if filtering_params.present? || sorting_params.present?
      videos =  Video.includes(:song, :leader, :follower, :event, :channel)
                      .references(:song, :leader, :follower, :event, :channel)
                      .pagy_search(params[:query],
                        filter: filter_array,
                        sort: [ "#{sort_column}:#{sort_direction}" ])

      @pagy, @videos = pagy_meilisearch(videos, items: 24)
    else
      @featured_videos =
      Video.includes(:song, :leader, :follower, :event, :channel)
            .references(:song, :leader, :follower, :event, :channel)
            .featured?
            .has_leader
            .has_follower
            .order("random()")
            .limit(24)

      videos =
      Video.includes(:song, :leader, :follower, :event, :channel)
            .references(:song, :leader, :follower, :event, :channel)
            .most_viewed_videos_by_month
            .has_leader
            .has_follower
            .order("random()")

      @pagy, @videos = pagy(videos, items: 24)
    end

    respond_to do |format|
      format.html # GET
      format.turbo_stream # POST
    end
  end

  def edit
    @clip = Clip.new
    set_recommended_videos
  end

  def show
    if @video.nil?
      Video::YoutubeImport.from_video(show_params[:v])
      @video = Video.find_by(youtube_id: show_params[:v])
      UpdateVideoWorker.perform_async(show_params[:v])
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
    @yt_comments = @video.yt_comments.limit(10)

    @video.clicked!

    if user_signed_in?
      MarkVideoAsWatchedJob.perform_async(show_params[:v], current_user.id)
    end
    ahoy.track("Video View", video_id: @video.id)
    @video.index!
  end

  def update
    @clip = Clip.new
    respond_to do |format|
      if @video.update(video_params)
        format.turbo_stream do
          render "videos/show", video: @video
        end
        format.html do
          render partial: "videos/show/video_info_details", video: @video
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
      @video.index!
    end
  end

  def create
    @video = Video.create(youtube_id: params[:video][:youtube_id])
    fetch_new_video
    @video.index!
    redirect_to root_path,
                notice:
                  "Video Sucessfully Added: The video must be approved before the videos are added"
  end

  def hide
    @video.hidden = true
    @video.save
    @video.index!
    render turbo_stream: turbo_stream.remove("video_#{@video.youtube_id}")
  end

  def upvote
    if current_user.voted_up_on? @video, vote_scope: "like"
      @video.unvote_by current_user, vote_scope: "like"
    else
      @video.upvote_by current_user, vote_scope: "like"
    end
    @video.index!
    render turbo_stream: turbo_stream.update("#{dom_id(@video)}_vote", partial: "videos/show/vote")
  end

  def downvote
    if current_user.voted_down_on? @video, vote_scope: "like"
      @video.unvote_by current_user, vote_scope: "like"
    else
      @video.downvote_by current_user, vote_scope: "like"
    end
    @video.index!
    render turbo_stream: turbo_stream.update("#{dom_id(@video)}_vote", partial: "videos/show/vote")
  end

  def bookmark
    if current_user.voted_up_on? @video, vote_scope: "bookmark"
      @video.unvote_by current_user, vote_scope: "bookmark"
    else
      @video.upvote_by current_user, vote_scope: "bookmark"
    end
    @video.index!
    render turbo_stream: turbo_stream.update("#{dom_id(@video)}_vote", partial: "videos/show/vote")
  end

  def complete
    if current_user.voted_up_on? @video, vote_scope: "watchlist"
      @video.unvote_by current_user, vote_scope: "watchlist"
    else
      @video.upvote_by current_user, vote_scope: "watchlist"
    end
    @video.index!
    render turbo_stream: turbo_stream.update("#{dom_id(@video)}_vote", partial: "videos/show/vote")
  end

  def watchlist
    if current_user.voted_down_on? @video, vote_scope: "watchlist"
      @video.unvote_by current_user, vote_scope: "watchlist"
    else
      @video.downvote_by current_user, vote_scope: "watchlist"
    end
    @video.index!
    render turbo_stream: turbo_stream.update("#{dom_id(@video)}_vote", partial: "videos/show/vote")
  end

  def featured
    @video.toggle!(:featured)
    @video.index!
    render turbo_stream: turbo_stream.update("#{dom_id(@video)}_vote", partial: "videos/show/vote")
  end

  def banner
  end

  private

  def set_video
    @video = Video.includes(:song, :leader, :follower, :event, :channel).find_by(youtube_id: show_params[:v]) if show_params[:v]
    @video = Video.includes(:song, :leader, :follower, :event, :channel).find_by(youtube_id: show_params[:id]) if show_params[:id]
    @video = Video.find_by(youtube_id: show_params[:video_id]) if show_params[:video_id]
  end

  def set_recommended_videos
    videos_from_this_performance
    videos_with_same_dancers
    videos_with_same_event
    videos_with_same_song
    videos_with_same_channel
  end

  def videos_from_this_performance
    @videos_from_this_performance = Video.includes(:song, :leader, :follower, :event, :channel)
                                         .where("upload_date <= ?", @video.upload_date + 7.days)
                                         .where("upload_date >= ?", @video.upload_date - 7.days)
                                         .where(channel_id: @video.channel_id)
                                         .where(leader_id: @video.leader_id)
                                         .where(follower_id: @video.follower_id)
                                         .order("performance_number ASC")
                                         .where(hidden: false)
                                         .limit(8).load_async
  end

  def videos_with_same_dancers
    @videos_with_same_dancers = Video.includes(:song, :leader, :follower, :event, :channel)
                                         .where("upload_date <= ?", @video.upload_date + 7.days)
                                         .where("upload_date >= ?", @video.upload_date - 7.days)
                                         .has_leader.has_follower
                                         .where(leader_id: @video.leader_id)
                                         .where(follower_id: @video.follower_id)
                                         .where(hidden: false)
                                         .where.not(youtube_id: @video.youtube_id)
                                         .limit(8).load_async
  end

  def videos_with_same_event
    @videos_with_same_event = Video.includes(:song, :leader, :follower, :event, :channel)
                                   .where(event_id: @video.event_id)
                                   .where.not(event: nil)
                                   .where("upload_date <= ?", @video.upload_date + 7.days)
                                   .where("upload_date >= ?", @video.upload_date - 7.days)
                                   .where(hidden: false)
                                   .where.not(youtube_id: @video.youtube_id)
                                   .limit(16).load_async
    @videos_with_same_event -= @videos_from_this_performance
  end

  def videos_with_same_song
    @videos_with_same_song = Video.includes(:song, :leader, :follower, :event, :channel)
                                  .where(song_id: @video.song_id)
                                  .has_leader.has_follower
                                  .where(hidden: false)
                                  .where.not(song_id: nil)
                                  .where.not(youtube_id: @video.youtube_id)
                                  .limit(8).load_async
  end

  def videos_with_same_channel
    @videos_with_same_channel = Video.includes(:song, :leader, :follower, :event, :channel)
                                  .where(channel_id: @video.channel_id)
                                  .has_leader.has_follower
                                  .where(hidden: false)
                                  .where.not(youtube_id: @video.youtube_id)
                                  .limit(8).load_async
  end

  def current_search
    @current_search = params[:query]
  end

  def video_params
    params
      .require(:video)
      .permit(:leader_id,
              :follower_id,
              :song_id,
              :event_id,
              :hidden,
              :"performance_date(1i)",
              :"performance_date(2i)",
              :"performance_date(3i)",
              :performance_number,
              :performance_total_number,
              :id)
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
      :id,
      :query,
      :dancer,
      :couples
    ).to_h
  end

  def sort_column
    @sort_column ||= sorting_params[:sort] || "popularity"
  end

  def sort_direction
    @sort_direction ||= sorting_params[:direction] || "desc"
  end

  def sorting_params
    params.permit(:direction, :sort)
  end

  def show_params
    params.permit(:v, :id, :video_id)
  end

  def filtering_for_dancer?
    return true if filtering_params.include?(:leader) || filtering_params.include?(:follower)
  end

  def dancer_name_match?
    if filtering_params.fetch(:query, false).present?
      Leader.full_name_search(filtering_params.fetch(:query, false)) || Follower.full_name_search(filtering_params.fetch(:query, false))
    end
  end
end
