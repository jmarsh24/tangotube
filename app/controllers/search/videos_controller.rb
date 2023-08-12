class Search::VideosController < ApplicationController
  def index
    @videos = Rails.cache.fetch(["search_videos", params[:query].presence], expires_in: 1.hour) do
      if params[:query].present?
        Video.search(params[:query])
          .with_attached_thumbnail
          .limit(12)
      else
        Video.all.limit(10).order(created_at: :desc)
      end
    end
  end
end
