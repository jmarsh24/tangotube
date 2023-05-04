# frozen_string_literal: true

class DancersController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :set_dancer, only: [:show, :edit, :update, :destroy]

  # @route GET /dancers (dancers)
  def index
    dancers = if params[:query].present?
      Dancer.search_by_full_name(params[:query]).order(:name)
    else
      Dancer.all.order(videos_count: :desc)
    end
    @pagy, @dancers = pagy(dancers, items: 12)

    respond_to do |format|
      format.html # GET
      format.turbo_stream # POST
      format.json do
        render json: Dancer.search_by_full_name(params[:query]).map { |dancer| {text: dancer.name, value: dancer.id} }
      end
    end
  end

  # @route POST /dancers/:id (dancer)
  # @route GET /dancers/:id (dancer)
  def show
    @orchestras = @dancer.orchestras
      .distinct
      .includes(profile_image_attachment: :blob)
      .order(videos_count: :desc)

    respond_to do |format|
      format.html # GET
      format.turbo_stream # POST
    end
  end

  # @route GET /dancers/new (new_dancer)
  def new
    @dancer = Dancer.new
  end

  # @route GET /dancers/:id/edit (edit_dancer)
  def edit
  end

  # @route POST /dancers (dancers)
  def create
    @dancer = Dancer.new(dancer_params)

    if @dancer.save
      redirect_to @dancer
    else
      render :new, status: :unprocessable_entity
    end
  end

  # @route PATCH /dancers/:id (dancer)
  # @route PUT /dancers/:id (dancer)
  def update
    if @dancer.update(dancer_params)
      redirect_to @dancer
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # @route DELETE /dancers/:id (dancer)
  def destroy
    @dancer.destroy
    redirect_to dancers_url
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_dancer
    @dancer = Dancer.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def dancer_params
    params.require(:dancer)
      .permit(:first_name,
        :last_name,
        :middle_name,
        :nick_name,
        :user_id,
        :bio,
        :slug,
        :reviewed,
        :couple_id,
        :profile_image,
        :cover_image)
  end

  def filtering_params
    params.permit(:orchestra,
      :year,
      :genre)
  end
end
