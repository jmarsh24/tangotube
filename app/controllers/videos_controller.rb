class VideosController < ApplicationController
  helper_method :sort_column, :sort_direction

  include Pagy::Backend

  def index
    @query = session[:query]
    @order_by = permitted_column_name(session[:order_by])
    @direction = permitted_direction(session[:direction])
    #byebug
    video = Video
    video = video.where(channel: params[:channel]).order(@order_by => @direction).where.not(leader: nil, follower: nil, song: nil) unless params[:channel].blank?
    video = video.includes(:leader).where(leader_id: params[:leader_id]).order(@order_by => @direction).where.not(leader: nil, follower: nil, song: nil) unless params[:leader_id].blank?
    video = video.includes(:follower).where(follower_id: params[:follower_id]).order(@order_by => @direction).where.not(leader: nil, follower: nil, song: nil) unless params[:follower_id].blank?
    video = video.includes(:event).where(event_id: params[:event_id]).order(@order_by => @direction).where.not(leader: nil, follower: nil, song: nil) unless params[:event_id].blank?
    video = video.includes(:videotype).where(videotype_id: params[:videotype_id]).order(@order_by => @direction).where.not(leader: nil, follower: nil, song: nil) unless params[:videotype_id].blank?
    video = video.includes(:song).where(:songs => {:genre => params[:genre] }).references(:songs).order(@order_by => @direction).where.not(leader: nil, follower: nil, song: nil) unless params[:genre].blank?
    video = video.all.order(@order_by => @direction).where.not(leader: nil, follower: nil, song: nil) if params[:leader_id].blank? and params[:follower_id].blank? and params[:channel_id].blank? and params[:event_id].blank? and params[:videotype_id].blank? and params[:genre].blank?
            # .videotype(params[:videotype_id]) unless params[:videotype_id].all?(&:blank?) 
            # .genre(params[:genre]) unless params[:genres].all?(&:blank?) 
            # .follower(params[:follower_id]) unless params[:follower_id].all?(&:blank?) 
            # .leader(params[:leader_id]) unless params[:leader_id].all?(&:blank?) 
            # .event(params[:event_id]) unless params[:event_id].all?(&:blank?) 
            # .channel(params[:channel]) unless params[:channel].all?(&:blank?) 
            # .order(@order_by => @direction)
            # .where.not(leader: nil, follower: nil, song: nil)
            
    video = video.search(@query) if @query.present?
    page_count   = (video.count / Pagy::VARS[:items].to_f).ceil
    
    @page = (session[:page] || 1).to_i
    @page = page_count if @page > page_count
    @pagy, @videos = pagy(video, page: @page, items: 100)

  

     @videotypes  = video.includes(:videotype).map(&:videotype).compact.uniq
     @genres      = video.includes(:song).pluck(:genre).compact.uniq.sort
     @leaders     = video.includes(:leader).map(&:leader).compact.uniq.sort
     @followers   = video.includes(:follower).map(&:follower).compact.uniq.sort
     @events      = video.includes(:event).map(&:event).compact.uniq.sort
     @channels    = video.pluck(:channel).compact.uniq.sort
   
     @songs = video.includes(:song).map(&:song).compact.uniq.sort

    # if params[:search_by_keyword]
    #          @videos = Video.filter(params.slice(:leader_id, :follower_id, :channel, :song_id, :view_count, :upload_date, :genre, :videotype_id, :event_id))
    #                         .order(sort_column + " " + sort_direction)
    #                         .includes(:leader, :follower, :song, :videotype, :event)
    #                         .search_by_keyword(params[:search_by_keyword])
    #                         .where.not(leader: nil, follower: nil, song: nil)

    #   @pagy, @v_pagination = pagy(Video.filter(params.slice(:leader_id, :follower_id, :channel, :song_id, :view_count, :upload_date, :genre, :videotype_id, :event_id))
    #                                    .order(sort_column + " " + sort_direction)
    #                                    .includes(:leader, :follower, :song, :videotype, :event)
    #                                    .search_by_keyword(params[:search_by_keyword])
    #                                    .where.not(leader: nil, follower: nil, song: nil), items: 100)
    # else
    #          @videos = Video.filter(params.slice(:leader_id, :follower_id, :channel, :genre, :videotype_id, :event_id))
    #                         .includes(:leader, :follower, :song, :videotype, :event)
    #                         .order(sort_column + " " + sort_direction)
    #                         .where.not(leader: nil, follower: nil, song: nil)
                            
    #   @pagy, @v_pagination = pagy(Video.filter(params.slice(:leader_id, :follower_id, :channel, :genre, :videotype_id, :event_id))
    #                                     .includes(:leader, :follower, :song, :videotype, :event)
    #                                     .order(sort_column + " " + sort_direction)
    #                                     .where.not(leader: nil, follower: nil, song: nil), items: 100)
    # end


    # @videos = Video.includes(:leader, :follower, :song, :videotype, :event)
    #                .where.not(leader: nil, follower: nil, song: nil).limit(1000)
    
  end

  def search
  
    @videos = Video.all.search_by_keyword(params[:search_by_keyword])

  end

private

  # def sort_column
  #   Video.column_names.include?(params[:sort]) ? params[:sort] : "upload_date"
  # end

  # def sort_direction
  #   %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  # end

  def permitted_column_name(column_name)
    %w[song_id follower_id leader_id channel song_genre event_id videotype_id view_count upload_date].find { |permitted| column_name == permitted } || "channel"
  end

  def permitted_direction(direction)
    %w[asc desc].find { |permitted| direction == permitted } || "asc"
  end

end