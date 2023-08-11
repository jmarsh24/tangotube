class Search::CouplesController < ApplicationController
  def index
    @couples = if params[:query].present?
      Couple.includes(dancer: {profile_image_attachment: :blob}, partner: {profile_image_attachment: :blob})
        .search(params[:query])
        .order(videos_count: :desc)
        .load_async
    else
      Couple.all.limit(10).order(videos_count: :desc).load_async
    end
  end
end
