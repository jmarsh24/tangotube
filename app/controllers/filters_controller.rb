class FiltersController < ApplicationController
  def index
    @filters = Filter.all.order(:id)
  end

  def show
    @filter = Filter.find(params[:id])
  end
end
