# frozen_string_literal: true

class BannerController < ApplicationController
  # @route GET /banner (banner)
  # @route POST /banner (banner)
  def index
    cookies.permanent[:banner_closed] = params[:banner_closed] if params[:banner_closed]
    ui.remove("banner")
  end
end
