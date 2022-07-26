class DancersController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :set_dancer, only: %i[ show edit update destroy ]

  # GET /dancers
  def index
    dancers = if params[:query].present?
      Dancer.where("unaccent(name) ILIKE unaccent(?)", "%#{params[:query]}%").order(:name)
    else
      Dancer.all.order(videos_count: :desc)
    end
    @pagy, @dancers = pagy(dancers, items: 12)

    respond_to do |format|
      format.html # GET
      format.turbo_stream # POST
    end
  end

  # GET /dancers/1
  def show
    @orchestras = @dancer.orchestras
                         .distinct
                         .includes(profile_image_attachment: :blob)
                         .order(videos_count: :desc)


    videos = Video.includes(:dancers, :orchestra)
                  .references(:dancers, :orchestra)
                  .where(dancers: { id: @dancer.id })

    @pagy, @videos = pagy(videos, items: 12)

    respond_to do |format|
      format.html # GET
      format.turbo_stream # POST
    end
  end

  # GET /dancers/new
  def new
    @dancer = Dancer.new
  end

  # GET /dancers/1/edit
  def edit
  end

  # POST /dancers
  def create
    @dancer = Dancer.new(dancer_params)

    if @dancer.save
      redirect_to @dancer, notice: "Dancer was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /dancers/1
  def update
    if @dancer.update(dancer_params)
      redirect_to @dancer, notice: "Dancer was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /dancers/1
  def destroy
    @dancer.destroy
    redirect_to dancers_url, notice: "Dancer was successfully destroyed."
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
