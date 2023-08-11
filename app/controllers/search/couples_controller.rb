class Search::CouplesController < ApplicationController
  def index
    @couples = if params[:query].present?
      Couple.includes(:dancer, :partner).search(params[:query]).load_async
    else
      Couple.all
    end
  end
end
