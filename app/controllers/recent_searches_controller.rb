# frozen_string_literal: true

class RecentSearchesController < ApplicationController
  before_action :authenticate_user!

  def index
    @recent_searches = current_user.recent_searches.includes(:searchable).unique_by_searchable.limit(10) if current_user
  end

  # @route POST /recent_searches (recent_searches)
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

  # @route DELETE /recent_searches/:id (recent_search)
  def destroy
    recent_search = RecentSearch.find(params[:id])
    recent_search.destroy
    ui.remove(recent_search)
  end

  private

  def recent_search_params
    params.require(:recent_search).permit(:resource_gid, :query, :category)
  end
end
