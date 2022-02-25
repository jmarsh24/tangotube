class Videos::CommentsController < ApplicationController
  include Commentable

  before_action :set_commentable

  private

    def set_commentable
      @commentable = Video.find(params[:video_id])
    end
end
