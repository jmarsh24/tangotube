class WatchersController < ApplicationController
  # GET /videos/:video_id/has_been_watched
  def has_been_watched
    if turbo_frame_request?
      video_id = params[:id]
      if current_user
        render "watched_status", locals: {watched: current_user.watches.exists?(video_id:), video_id:}
      end
    end
  end
end
