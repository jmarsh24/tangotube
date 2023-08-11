class Search::OrchestrasController < ApplicationController
  def index
    @orchestras = if params[:query].present?
      Orchestra.search(params[:query]).load_async
    else
      Orchestra.all
    end
  end
end
