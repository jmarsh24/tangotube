class EventsController < ApplicationController
  def index
    @events = Event.title_search(params[:q]).distinct.order(:title).pluck(:title, :id)
    render json: @events
  end
end
