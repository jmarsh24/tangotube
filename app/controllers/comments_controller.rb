# frozen_string_literal: true

class CommentsController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :authenticate_user!
  before_action :set_commentable

  def show
    @comment = Comment.find(params[:id])
    authorize @comment
  end

  def edit
    @comment = Comment.find(params[:id])
    authorize @comment
  end

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    authorize @comment

    if @comment.save && @comment.parent_id.nil?
      render turbo_stream: turbo_stream.append("comments", partial: "comments/comment", locals: {comment: @comment})
    elsif @comment.save && @comment.parent_id.present?
      render turbo_stream: turbo_stream.append("comment_#{comment_params[:parent_id]}_comments", partial: "comments/comment", locals: {comment: @comment})
    else
      redirect_to @commentable
    end
  end

  def update
    @comment = Comment.find(params[:id])
    authorize @comment

    if @comment.update(comment_params)
      render turbo_stream: turbo_stream.update(dom_id(@comment), partial: "comments/comment", locals: {comment: @comment})
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    authorize @comment
    @comment.destroy

    if @comment.comments.any?
      render turbo_stream: turbo_stream.update(dom_id(@comment), partial: "comments/comment", locals: {comment: @comment})
    else
      render turbo_stream: turbo_stream.remove(dom_id(@comment))
    end
  end

  private

  def set_commentable
    @commentable = find_commentable
    authorize @commentable
  end

  def find_commentable
    params.each do |name, value|
      return $1.classify.constantize.find(value) if name =~ /(.+)_id$/
    end
    nil
  end

  def comment_params
    params.require(:comment).permit(:body, :parent_id)
  end
end
