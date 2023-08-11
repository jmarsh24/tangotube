class Search::DancersController < ApplicationController
  def index
    @dancers = if params[:query].present?
      Dancer.search(params[:query]).load_async
    else
      Dancer.all
    end
  end
end
