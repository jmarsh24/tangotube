class ClipsController < ApplicationController
  before_action :set_clip, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, only: %i[ new edit update destroy]
  before_action :set_video, only: %i[ create show edit update destroy ]

  # GET /clips
  def index
    @pagy, @clips = pagy(Clip.all.includes(:video).order(created_at: :desc), items: 12)
  end

  # GET /clips/1
  def show; end

  # GET /clips/new
  def new
    @clip = Clip.new
  end

  # GET /clips/1/edit
  def edit; end


  # POST /clips
  def create
    @clip = Clip.new(clip_params)
    @clip.user = current_user
    @clip.video = @video

    if @clip.save
      respond_to do |format|
        format.html do
          redirect_to watch_path( v: @clip.video.youtube_id,
                                  start: @clip.start_seconds,
                                  end: @clip.end_seconds,
                                  speed: @clip.playback_rate),
                                  notice: "Clip was successfully created. Click #{view_context.link_to('Here', clips_path)} to view your clip."
        end
        format.turbo_stream do
          flash.now[:notice] = "Clip was successfully created. Click #{view_context.link_to('Here',clips_path)} to view your clip."
        end
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /clips/1
  def update
    if @clip.update(clip_params)
      redirect_to video_clips_path(@video), notice: "Clip was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /clips/1
  def destroy
    @clip.destroy
    redirect_to video_clips_path(@video), notice: "Clip was successfully destroyed."
  end

  private
    def set_video
      @video = Video.find(params[:video_id]) if params[:video_id].present?
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_clip
      @clip = Clip.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def clip_params
      params.require(:clip).permit(:start_seconds, :end_seconds, :title, :playback_rate, :tags, :user_id, :video_id)
    end
end
