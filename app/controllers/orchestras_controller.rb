# frozen_string_literal: true

class OrchestrasController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :set_orchestra, only: %i[show edit update destroy]

  # GET /orchestras
  def index
    orchestras = if params[:query].present?
      Orchestra.where("unaccent(name) ILIKE unaccent(?)", "%#{params[:query]}%").order(:name).with_attached_profile_image
    else
      Orchestra.all.order(videos_count: :desc).with_attached_profile_image
    end
    @pagy, @orchestras = pagy(orchestras, items: 12)

    respond_to do |format|
      format.html # GET
      format.turbo_stream # POST
    end
  end

  # GET /orchestras/1
  def show
    @dancers = @orchestra.dancers.distinct.includes(profile_image_attachment: :blob).order(videos_count: :desc)
    @couples = Couple.includes(partner: {profile_image_attachment: :blob}, dancer: {profile_image_attachment: :blob})
      .where(id: Couple.select("DISTINCT ON (unique_couple_id) *").map(&:id))
      .order(videos_count: :desc)

    videos = @orchestra.videos
    @pagy, @videos = pagy(videos, items: 12)

    respond_to do |format|
      format.html # GET
      format.turbo_stream # POST
    end
  end

  # GET /orchestras/new
  def new
    @orchestra = Orchestra.new
  end

  # GET /orchestras/1/edit
  def edit
  end

  # POST /orchestras
  def create
    @orchestra = Orchestra.new(orchestra_params)

    if @orchestra.save
      redirect_to @orchestra, notice: "Orchestra was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /orchestras/1
  def update
    if @orchestra.update(orchestra_params)
      redirect_to @orchestra, notice: "Orchestra was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /orchestras/1
  def destroy
    @orchestra.destroy
    redirect_to orchestras_url, notice: "Orchestra was successfully destroyed."
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_orchestra
    @orchestra = Orchestra.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def orchestra_params
    params.require(:orchestra)
      .permit(:song_id,
        :video_id,
        :name,
        :bio,
        :slug,
        :profile_image,
        :cover_image)
  end
end
