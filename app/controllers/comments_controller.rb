class CommentsController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :authenticate_user!

  def show
    @comment = Comment.find params[:id]
  end
  def edit
    @comment = Comment.find params[:id]
  end
  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    if @comment.save && @comment.parent_id.nil?
      render turbo_stream: turbo_stream.append("comments", partial: "comments/comment", locals: { comment: @comment })
    elsif @comment.save && @comment.parent_id.present?
      render turbo_stream: turbo_stream.append("comment_#{@comment.parent_id}_comments", partial: "comments/comment", locals: { comment: @comment })
    else
      redirect_to @commentable, alert: "Something went wrong"
    end
  end



  def update
    @comment = Comment.find params[:id]

    if @comment.update comment_params
      render turbo_stream: turbo_stream.update(dom_id(@comment), partial: "comments/comment", locals: { comment: @comment })
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    if @comment.comments.any?
      render turbo_stream: turbo_stream.update(dom_id(@comment), partial: "comments/comment", locals: { comment: @comment })
    else
      render turbo_stream: turbo_stream.remove(dom_id(@comment))
    end
  end

  private

    def comment_params
      params.require(:comment).permit(:body, :parent_id)
    end
end
