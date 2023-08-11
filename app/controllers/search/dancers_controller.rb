class Search::DancersController < ApplicationController
  def index
    @dancers = if params[:query].present?
      Dancer.search(params[:query])
        .with_attached_profile_image
        .order(videos_count: :desc)
        .limit(10)
        .load_async
    else
      Dancer.all.limit(10).order(videos_count: :desc).load_async
    end
  end
end
