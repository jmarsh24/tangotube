# frozen_string_literal: true

class WatchersController < ApplicationController
  # @route GET /videos/:id/watched_by_current_user (watched_by_current_user_video)
  def watched_status
    require_turbo_frame
    if current_user
      @current_user = current_user
      @video_id = params[:id]
      @watched = current_user.watches.exists?(video_id: @video_id)
    end
  end
end
