class VideosController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :authenticate_user!, only: %i[edit update create upvote downvote bookmark watchlist complete]
  before_action :current_search, only: %i[index]
  before_action :set_video, only: %i[show edit update destroy upvote downvote bookmark watchlist complete featured]

  helper_method :sorting_params, :filtering_params

  def index
    @page = page
    @sort_column = sort_column
    @sort_direction = sort_direction

    filters = filtering_params.except(:query, :liked, :watched)

    if sorting_params.present?
      order = { sort_column => sort_direction }
    end

    if user_signed_in?
      user_id = current_user.id
    end

    if filtering_params.include?("watched")
      if filtering_params["watched"] == "true"
        filters.merge!({ watched_by: current_user.id })
      end
      if filtering_params["watched"] == "false"
        filters.merge!({ not_watched_by: current_user.id })
      end
    end

    if filtering_params.include?("liked")
      if filtering_params["liked"] == "true"
        filters.merge!({ liked_by: current_user.id })
      end

      if filtering_params["liked"] == "false"
        filters.merge!({ disliked_by: current_user.id })
      end
    end

    if filtering_params.present? || sorting_params.present?
      videos = Video.pagy_search(filtering_params[:query].presence || "*",
                                          where: filters,
                                          order: order,
                                          includes: [:song, :leader, :follower, :event, :channel],
                                          fields: ["title^10", "leader^10", "follower^10", "song_title^5", "song_artist^5"],
                                          boost_by: [:popularity],
                                          misspellings: {edit_distance: 5},
                                          body_options: {track_total_hits: true},
                                          boost_by_recency: {updated_at: {scale: "7d", decay: 0.5}},
                                          boost_where: {watched_by: user_id})
    else
      videos = Video.pagy_search("*",
        includes: [:song, :leader, :follower, :event, :channel],
        body: {
          query: {
            function_score: {
              query: {
                match: { has_leader: true },
                match: { has_follower: true },
                match: { viewed_within_last_month: true },
                },
              random_score: {
                seed: DateTime.now.to_i
              }
            }
          }
        })

      if page == 1
        featured_videos = Video.includes(:song, :leader, :follower, :event, :channel)
                              .where(featured: true)
                              .order("random()")

        featured_videos_length = featured_videos.length

        if featured_videos_length < 4
          featured_videos = []
          elsif featured_videos_length < 12
            featured_videos = featured_videos.limit(4)
          elsif featured_videos_length > 12 && featured_videos_length < 24
            featured_videos = featured_videos.limit(12)
          elsif featured_videos_length >= 24
            featured_videos = featured_videos.limit(24)
        end


        @featured_videos = featured_videos
      end

      @pagy, @videos = pagy_searchkick(videos, items: 24)
    end

    if @page == 1
      video_search = Video.search(filtering_params[:query].presence || "*",
                                    where: filters,
                                    aggs: [:genre, :leader, :follower, :orchestra, :year],
                                    misspellings: {edit_distance: 10})

      @genres= video_search.aggs["genre"]["buckets"]
                            .sort_by{ |b| b["doc_count"] }
                            .reverse.map{ |bucket| ["#{bucket['key'].titleize} (#{bucket['doc_count']})", bucket["key"].parameterize] }

      @leaders= video_search.aggs["leader"]["buckets"]
                            .sort_by{ |b| b["doc_count"] }
                            .reverse.map{ |bucket| ["#{bucket['key'].titleize} (#{bucket['doc_count']})", bucket["key"].parameterize] }

      @followers= video_search.aggs["follower"]["buckets"]
                              .sort_by{ |b| b["doc_count"] }
                              .reverse.map{ |bucket| ["#{bucket['key'].titleize} (#{bucket['doc_count']})", bucket["key"].parameterize] }

      @orchestras= video_search.aggs["orchestra"]["buckets"]
                              .sort_by{ |b| b["doc_count"] }
                              .reverse.map{ |bucket| ["#{bucket['key'].titleize} (#{bucket['doc_count']})", bucket["key"].parameterize] }

      @years= video_search.aggs["year"]["buckets"]
                          .sort_by{ |b| b["key"] }
                          .reverse.map{ |bucket| ["#{bucket['key'].titleize} (#{bucket['doc_count']})", bucket["key"].parameterize] }
    end

    if sorting_params.empty? && @pagy.next && (filtering_for_dancer? || dancer_name_match?)

      @videos_most_recent = Video.search(filtering_params[:query].presence || "*",
                                    where: filters,
                                    order: { "year" => "desc" },
                                    includes: [:song, :leader, :follower, :event, :channel],
                                    limit: 8)

      @videos_oldest = Video.search(filtering_params[:query].presence || "*",
                              where: filters,
                              order: { "year" => "asc" },
                              includes: [:song, :leader, :follower, :event, :channel],
                              limit: 8)

      @videos_most_viewed = Video.search(filtering_params[:query].presence || "*",
                                    where: filters,
                                    order: { "view_count" => "desc" },
                                    includes: [:song, :leader, :follower, :event, :channel],
                                    limit: 8)
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
    if @video.present?
      UpdateVideoWorker.perform_async(@video.youtube_id)
    else
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
  end

  def update
    @clip = Clip.new
    respond_to do |format|
      if @video.update(video_params)
        # format.turbo_stream do
        #   render "videos/show", video: @video
        # end
        format.html do
          render partial: "videos/show/video_info_details", video: @video
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def create
    @video = Video.create(youtube_id: params[:video][:youtube_id])
    fetch_new_video

    redirect_to root_path,
                notice:
                  "Video Sucessfully Added: The video must be approved before the videos are added"
  end

  def upvote
    if current_user.voted_up_on? @video, vote_scope: "like"
      @video.unvote_by current_user, vote_scope: "like"
    else
      @video.upvote_by current_user, vote_scope: "like"
    end
    render turbo_stream: turbo_stream.update("#{dom_id(@video)}_vote", partial: "videos/show/vote")
  end

  def downvote
    if current_user.voted_down_on? @video, vote_scope: "like"
      @video.unvote_by current_user, vote_scope: "like"
    else
      @video.downvote_by current_user, vote_scope: "like"
    end
    render turbo_stream: turbo_stream.update("#{dom_id(@video)}_vote", partial: "videos/show/vote")
  end

  def bookmark
    if current_user.voted_up_on? @video, vote_scope: "bookmark"
      @video.unvote_by current_user, vote_scope: "bookmark"
    else
      @video.upvote_by current_user, vote_scope: "bookmark"
    end
    render turbo_stream: turbo_stream.update("#{dom_id(@video)}_vote", partial: "videos/show/vote")
  end

  def complete
    if current_user.voted_up_on? @video, vote_scope: "watchlist"
      @video.unvote_by current_user, vote_scope: "watchlist"
    else
      @video.upvote_by current_user, vote_scope: "watchlist"
    end
    render turbo_stream: turbo_stream.update("#{dom_id(@video)}_vote", partial: "videos/show/vote")
  end

  def watchlist
    if current_user.voted_down_on? @video, vote_scope: "watchlist"
      @video.unvote_by current_user, vote_scope: "watchlist"
    else
      @video.downvote_by current_user, vote_scope: "watchlist"
    end
    render turbo_stream: turbo_stream.update("#{dom_id(@video)}_vote", partial: "videos/show/vote")
  end

  def featured
    if current_user.voted_up_on? @video, vote_scope: "featured"
      @video.unvote_by current_user, vote_scope: "featured"
    else
      @video.upvote_by current_user, vote_scope: "featured"
    end
    render turbo_stream: turbo_stream.update("#{dom_id(@video)}_vote", partial: "videos/show/vote")
  end

  private

  def set_video
    @video = Video.includes(:song, :leader, :follower, :event, :channel).find_by(youtube_id: show_params[:v]) if show_params[:v]
    @video = Video.includes(:song, :leader, :follower, :event, :channel).find_by(youtube_id: show_params[:id]) if show_params[:id]
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

  def page
    @page ||= params.permit(:page).fetch(:page, 1).to_i
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
      :song_id,
      :hd,
      :event_id,
      :year,
      :watched,
      :liked,
      :id,
      :query,
      :dancer
    ).to_h
  end

  def sort_column
    @sort_column ||= sorting_params[:sort]
  end

  def sort_direction
    @sort_direction ||= sorting_params[:direction]
  end

  def sorting_params
    params.permit(:direction, :sort)
  end

  def show_params
    params.permit(:v, :id)
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
