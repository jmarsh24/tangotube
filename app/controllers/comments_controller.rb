class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    if @comment.save
      respond_to do |format|
        format.html { redirect_to @commentable }
        format.js
      end
    else
      redirect_to @commentable, alert: "Something went wrong"
    end
  end

  def edit
    @comment = Comment.find params[:id]
  end

  def update
    @comment = comment.find params[:id]

    if @comment.update comment_params
      redirect_to comment_url(@comment)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @comment = @commentable.comments.find(params[:id])
    @comment.destroy
    redirect_to @commentable
  end

  private

    def comment_params
      params.require(:comment).permit(:body, :parent_id)
    end
end
