class Search::OrchestrasController < ApplicationController
  def index
    @orchestras = Rails.cache.fetch(["search_orchestras", params[:query].presence], expires_in: 1.hour) do
      if params[:query].present?
        Orchestra.search(params[:query])
          .with_attached_profile_image
          .limit(10)
      else
        Orchestra.all.limit(10).order(videos_count: :desc)
      end
    end
  end
end
