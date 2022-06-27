class CookiesController < ApplicationController
  def index
    session[:cookies_accepted] = params[:cookies_accepted] if params[:cookies_accepted]
  end
end
