class Search::DancersController < ApplicationController
  def index
    @dancers = Rails.cache.fetch(["search_dancers", params[:query].presence], expires_in: 1.hour) do
      if params[:query].present?
        Dancer.search(params[:query])
          .with_attached_profile_image
          .limit(10)
      else
        Dancer.all.limit(10).order(videos_count: :desc)
      end
    end
  end
end
