class FollowersController < ApplicationController
  def index
    @followers = Follower.full_name_search(params[:q]).distinct.order(:name).pluck(:name, :id)
    render json: @followers
  end
end
