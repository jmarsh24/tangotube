class Search::OrchestrasController < ApplicationController
  def index
    @orchestras = if params[:query].present?
      Orchestra.search(params[:query])
        .with_attached_profile_image
        .load_async
    else
      Orchestra.all.limit(10).order(videos_count: :desc).load_async
    end
  end
end
