class LeadersController < ApplicationController
  def index
    @leaders = Leader.all.order(:name).pluck(:name)
    render json: @leaders
  end
end
