# frozen_string_literal: true

class WatchersController < ApplicationController
  # @route GET /videos/:id/watched_by_current_user (watched_by_current_user_video)
  def has_been_watched
    if turbo_frame_request?
      video_id = params[:id]
      if current_user
        render "watched_status", locals: {watched: current_user.watches.exists?(video_id:), video_id:}
      end
    end
  end
end
