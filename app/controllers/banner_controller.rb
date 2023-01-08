# frozen_string_literal: true

class BannerController < ApplicationController
  def index
    session[:banner_closed] = params[:banner_closed] if params[:banner_closed]
  end
end
