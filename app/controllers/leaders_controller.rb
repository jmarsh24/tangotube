class LeadersController < ApplicationController
  def index
    @leaders =
      Leader
        .full_name_search(params[:q])
        .distinct
        .order(:name)
        .pluck(:name, :id)
    render json: @leaders
  end
end
