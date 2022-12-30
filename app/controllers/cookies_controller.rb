class CookiesController < ApplicationController
  def index
    cookies[:cookies_accepted] = params[:cookies_accepted] if params[:cookies_accepted]
  end
end
