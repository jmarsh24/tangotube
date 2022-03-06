class DiscussionsController < ApplicationController
  before_action :set_discussion, only: %i[ show edit update destroy ]

  # GET /discussions
  def index
    @discussions = Discussion.all
  end

  # GET /discussions/1
  def show
  end

  # GET /discussions/new
  def new
    @discussion = Discussion.new
  end

  # GET /discussions/1/edit
  def edit
  end

  # POST /discussions
  def create
    @discussion = Discussion.new(discussion_params)

    if @discussion.save
      redirect_to @discussion, notice: "Discussion was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /discussions/1
  def update
    if @discussion.update(discussion_params)
      redirect_to @discussion, notice: "Discussion was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /discussions/1
  def destroy
    @discussion.destroy
    redirect_to discussions_url, notice: "Discussion was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_discussion
      @discussion = Discussion.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def discussion_params
      params.require(:discussion).permit(:title)
    end
end
