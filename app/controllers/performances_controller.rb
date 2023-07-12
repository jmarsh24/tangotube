# frozen_string_literal: true

class PerformancesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_performance, only: [:show, :edit, :update, :destroy]
  before_action :authorize_admin!, except: [:index, :show]

  # @route GET /performances (performances)
  def index
    performances = Performance.where("videos_count < 7").includes(:videos).order(videos_count: :desc)
    @pagy, @performances = pagy(performances, items: 12)

    respond_to do |format|
      format.html # GET
      format.turbo_stream # POST
    end
  end

  # @route GET /performances/:id (performance)
  def show
  end

  def new
    @performance = Performance.new
  end

  def edit
  end

  # @route POST /performances (performances)
  def create
    @performance = Performance.new(performance_params)

    if @performance.save
      redirect_to @performance
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @performance.update(performance_params)
      redirect_to @performance
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @performance.destroy
    redirect_to performances_url
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_performance
    @performance = Performance.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def performance_params
    params.require(:performance).permit(:event_id, :date, :video_id, :videos_count, :position, :slug)
  end

  def authorize_admin!
    unless current_user&.admin?
      flash[:alert] = "You do not have permission to perform this action."
      redirect_to root_path
    end
  end
end
