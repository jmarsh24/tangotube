# frozen_string_literal: true

class PerformancesController < ApplicationController
  before_action :set_performance, only: %i[show edit update destroy]

  # @route POST /performances (performances)
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

  # @route GET /performances/new (new_performance)
  def new
    @performance = Performance.new
  end

  # @route GET /performances/:id/edit (edit_performance)
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

  # @route PATCH /performances/:id (performance)
  # @route PUT /performances/:id (performance)
  def update
    if @performance.update(performance_params)
      redirect_to @performance
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # @route DELETE /performances/:id (performance)
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
end
