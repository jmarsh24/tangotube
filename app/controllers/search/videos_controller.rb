class Search::VideosController < ApplicationController
  def index
    @videos = if params[:query].present?
      Video.search(params[:query])
        .with_attached_thumbnail
        .limit(24)
        .load_async
    else
      Video.all.limit(10).order(created_at: :desc).load_async
    end
  end
end
