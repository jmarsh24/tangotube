# frozen_string_literal: true

class RecentSearchesController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user
      searchables_to_preload = {
        "Event" => {profile_image_attachment: :blob},
        "Song" => {orchestra: {profile_image_attachment: :blob}},
        "Orchestra" => {profile_image_attachment: :blob},
        "Channel" => {thumbnail_attachment: :blob},
        "Video" => {thumbnail_attachment: :blob},
        "Dancer" => {profile_image_attachment: :blob},
        "Couple" => {profile_image_attachment: :blob}
      }

      distinct_searchable_types = current_user.recent_searches.select(:searchable_type).distinct.pluck(:searchable_type)

      preloaded_searches = []

      distinct_searchable_types.each do |type|
        if searchables_to_preload[type]
          type_searches = current_user.recent_searches.where(searchable_type: type).preload(searchable: searchables_to_preload[type])
          preloaded_searches.concat(type_searches)
        end
      end

      @recent_searches = preloaded_searches.uniq(&:searchable_id).sort_by(&:created_at).reverse.take(10)
    end
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
