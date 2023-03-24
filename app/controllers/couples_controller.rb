# frozen_string_literal: true

class CouplesController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :set_couple, only: %i[show edit update destroy]

  # @route POST /couples (couples)
  # @route GET /couples (couples)
  def index
    couples = if params[:query].present?
      Couple.where("unaccent(slug) ILIKE unaccent(?)", "%#{params[:query]}%").order(videos_count: :desc)
    else
      Couple.where(id: Couple.select("DISTINCT ON (unique_couple_id) *").map(&:id)).order(videos_count: :desc)
    end
    @pagy, @couples = pagy(couples, items: 12)
  end

  # @route POST /couples/:id (couple)
  # @route GET /couples/:id (couple)
  def show
    videos = @couple.videos
    @pagy, @videos = pagy(videos, items: 12)

    respond_to do |format|
      format.html # GET
      format.turbo_stream # POST
    end
  end

  # @route GET /couples/new (new_couple)
  def new
    @couple = Couple.new
  end

  # @route GET /couples/:id/edit (edit_couple)
  def edit
  end

  # @route POST /couples (couples)
  def create
    @couple = Couple.new(couple_params)

    if @couple.save
      redirect_to @couple
    else
      render :new, status: :unprocessable_entity
    end
  end

  # @route PATCH /couples/:id (couple)
  # @route PUT /couples/:id (couple)
  def update
    if @couple.update(couple_params)
      redirect_to @couple
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # @route DELETE /couples/:id (couple)
  def destroy
    @couple.destroy
    redirect_to couples_url
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
