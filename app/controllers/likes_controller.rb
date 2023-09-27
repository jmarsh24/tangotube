# frozen_string_literal: true

class LikesController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :authenticate_user!
  before_action :set_likeable, only: [:create]

  # @route POST /likes (likes)
  def create
    @like = @likeable.likes.new(user: current_user)
    if @like.save
      respond_to do |format|
        format.turbo_stream { ui.replace(dom_id(@likeable, "like-button"), with: "shared/like_button", likeable: @likeable) }
        format.html { redirect_to @likeable }
      end
    end
  end

  # @route DELETE /likes/:id (like)
  def destroy
    @like = current_user.likes.find(params[:id])

    likeable = @like.likeable
    if @like.destroy
      respond_to do |format|
        format.turbo_stream { ui.replace(dom_id(likeable, "like-button"), with: "shared/like_button", likeable:) }
        format.html { redirect_to likeable }
      end
    end
  end

  private

  def set_likeable
    @likeable_type = params[:likeable_type].classify
    @likeable = @likeable_type.constantize.find(params[:likeable_id])
  end
end
