class BannerController < ApplicationController
  def index
    cookies[:banner_closed] = params[:banner_closed] if params[:banner_closed]
  end
end
