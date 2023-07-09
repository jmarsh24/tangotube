# frozen_string_literal: true

class ClipsController < ApplicationController
  before_action :set_clip, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :edit, :update, :destroy]
  before_action :set_video, only: [:create, :show, :edit, :update, :destroy]

  # @route POST /clips (clips)
  # @route GET /clips (clips)
  def index
    @clips = Clip.all.includes(:video).order(created_at: :desc)
    @clips = @clips.tagged_with(params[:tag]) if params[:tag].present?
    authorize @clips
    @clips = paginated(@clips)
  end

  # @route POST /clips/:id (clip)
  # @route GET /clips/:id (clip)
  def show
    authorize @clip
  end

  def new
    @clip = Clip.new
    authorize @clip
  end

  def edit
    authorize @clip
  end

  # @route POST /clips (clips)
  def create
    @clip = Clip.new(clip_params)
    @clip.user = current_user
    @clip.video = @video
    authorize @clip

    if @clip.save
      respond_to do |format|
        format.html do
          redirect_to watch_path(v: @clip.video.youtube_id,
            start: @clip.start_seconds,
            end: @clip.end_seconds,
            speed: @clip.playback_rate)
        end
        format.turbo_stream do
          flash.now[:notice] = "Clip was successfully created. Click #{view_context.link_to("Here", clips_path)} to view your clip."
        end
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize @clip

    if @clip.update(clip_params)
      redirect_to clips_path(@clip)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @clip
    @clip.destroy
    respond_to do |format|
      format.html { redirect_to clips_path }
      format.turbo_stream
    end
  end

  private

  def set_video
    @video = Video.find(params[:video_id]) if params[:video_id].present?
  end

  def set_clip
    @clip = Clip.find(params[:id])
  end

  def clip_params
    params.require(:clip).permit(:start_seconds, :end_seconds, :title, :playback_rate, :user_id, :video_id, :tag_list)
  end
end
