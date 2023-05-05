# frozen_string_literal: true

class BannerController < ApplicationController
  # @route GET /banner (banner)
  # @route POST /banner (banner)
  def index
    if params[:banner_closed]
      cookies.permanent[:banner_closed] = params[:banner_closed]
    else
      cookies.delete(:banner_closed)
    end
    ui.remove("banner")
  end
end
