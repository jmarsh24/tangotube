class Search::VideosController < ApplicationController
  def index
    @videos = if params[:query].present?
      Video.search(params[:query])
    else
      Video.all.most_popular
    end
  end
end
