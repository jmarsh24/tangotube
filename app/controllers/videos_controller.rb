class VideosController < ApplicationController
  # before_action :authenticate_user!

  NUMBER_OF_VIDEOS_PER_PAGE = 50.freeze
  HERO_YOUTUBE_ID = 's6iptZdCcG0'.freeze

  helper_method :sort_column, :sort_direction

  def index
    @active_video = Video.find_by(youtube_id: active_youtube_id)
    
    @videos = Video

    @videos = @videos.search(params[:q]) if params[:q].present?
    
    @videos = @videos.includes(:song, :leader, :follower, :videotype, :event)
                   .where.not(leader: nil)
                   .where.not(follower: nil)
                   .where.not(song: nil)
                   .order(sort_column + " " + sort_direction)
                   .limit(NUMBER_OF_VIDEOS_PER_PAGE)
                   .offset(NUMBER_OF_VIDEOS_PER_PAGE * page)
  end

private

  def active_youtube_id
    @active_youtube_id ||= params[:youtube_id] || HERO_YOUTUBE_ID
  end

  def sort_column
    acceptable_cols = [ "songs.artist",
                          "songs.genre",
                          "leader_id",
                          "follower_id",
                          "channel",
                          "upload_date",
                          "view_count",
                          "song_id",
                          "videotype_id",
                          "event_id"]
    acceptable_cols.include?(params[:sort]) ? params[:sort] : "upload_date"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def page
    @page ||= params.permit(:page).fetch(:page, 1).to_i
  end
end
