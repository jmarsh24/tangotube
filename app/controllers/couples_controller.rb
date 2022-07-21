class CouplesController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :set_couple, only: %i[ show edit update destroy ]

  # GET /couples
  def index
    couples = if params[:query].present?
      Couple.where("unaccent(slug) ILIKE unaccent(?)", "%#{params[:query]}%").order(videos_count: :desc)
    else
      Couple.where(unique_couple_id: Couple.select(:unique_couple_id).distinct.pluck(:unique_couple_id)).order(videos_count: :desc)
    end
    @pagy, @couples = pagy(couples, items: 12)
  end

  # GET /couples/1
  def show
    videos = @couple.videos
    @pagy, @videos = pagy(videos, items: 12)

    respond_to do |format|
      format.html # GET
      format.turbo_stream # POST
    end
  end

  # GET /couples/new
  def new
    @couple = Couple.new
  end

  # GET /couples/1/edit
  def edit; end

  # POST /couples
  def create
    @couple = Couple.new(couple_params)

    if @couple.save
      redirect_to @couple, notice: "Couple was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /couples/1
  def update
    if @couple.update(couple_params)
      redirect_to @couple, notice: "Couple was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /couples/1
  def destroy
    @couple.destroy
    redirect_to couples_url, notice: "Couple was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_couple
      @couple = Couple.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def couple_params
      params.require(:couple).permit(:dancer_id, :feature_image)
    end
end
