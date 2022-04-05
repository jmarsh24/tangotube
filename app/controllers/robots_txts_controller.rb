class RobotsTxtsController < ApplicationController

  def show
    if disallow_all_crawlers?
      render "disallow_all", layout: false, content_type: "text/plain"
    else
      render nothing: true, status: :not_found
    end
  end

  private

  def disallow_all_crawlers?
    ENV["DISALLOW_ALL_WEB_CRAWLERS"].present?
  end
end
