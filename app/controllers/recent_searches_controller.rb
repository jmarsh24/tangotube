class RecentSearchesController < ApplicationController
  before_action :authenticate_user!

  def create
    resource = GlobalID::Locator.locate recent_search_params[:resource_gid]
    head :unprocessable_entity and return unless resource

    recent_search = current_user.recent_searches.build(searchable: resource, query: recent_search_params[:query], category: recent_search_params[:category])
    if recent_search.save
      head :created
    else
      head :unprocessable_entity
    end
  end

  private

  def recent_search_params
    params.require(:recent_search).permit(:resource_gid, :query, :category)
  end
end
