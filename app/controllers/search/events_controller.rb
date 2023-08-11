class Search::EventsController < ApplicationController
  def index
    @events = if params[:query].present?
      Event.search(params[:query])
        .with_attached_profile_image
        .order(videos_count: :desc)
        .limit(10)
        .load_async
    else
      Event.all.limit(10).order(videos_count: :desc).load_async
    end
  end
end
