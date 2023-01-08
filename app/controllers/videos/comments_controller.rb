# frozen_string_literal: true

class Videos::CommentsController < CommentsController
  before_action :set_commentable

  private

  def set_commentable
    @commentable = Video.find(params[:video_id])
  end
end
