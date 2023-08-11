class Search::EventsController < ApplicationController
  def index
    @events = if params[:query].present?
      Event.search(params[:query]).load_async
    else
      Event.all
    end
  end
end
