# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :set_event, only: %i[show edit update destroy]

  # @route POST /events (events)
  # @route GET /events (events)
  def index
    events = Event.all.order(videos_count: :desc)
    events = if params[:q].present?
      Event.where("unaccent(title) ILIKE unaccent(?)", "%#{params[:q]}%").order(videos_count: :desc)
    else
      Event.all.order(videos_count: :desc)
    end
    @pagy, @events = pagy(events, items: 12)
    respond_to do |format|
      format.html
      format.turbo_stream
      format.json do
        render json: events.map { |event| {text: event.title, value: event.id} }
      end
    end
  end

  # @route POST /events/:id (event)
  # @route GET /events/:id (event)
  def show
    videos = @event.videos
    @pagy, @videos = pagy(videos, items: 12)
    respond_to do |format|
      format.html # GET
      format.turbo_stream # POST
    end
  end

  # @route GET /events/new (new_event)
  def new
    @event = Event.new
  end

  # @route GET /events/:id/edit (edit_event)
  def edit
  end

  # @route POST /events (events)
  def create
    @event = Event.create(title: params[:event][:title],
      city: params[:event][:city],
      country: params[:event][:country])
    if @event.save
      match_event(@event.id)
      redirect_to root_path
    else
      redirect_to events_path
    end
  end

  # @route PATCH /events/:id (event)
  # @route PUT /events/:id (event)
  def update
    if @event.update(event_params)
      redirect_to @event
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # @route DELETE /events/:id (event)
  def destroy
    @event.destroy
    redirect_to events_url
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def event_params
    params.require(:event)
      .permit(:title,
        :city,
        :country,
        :start_date,
        :end_date,
        :active,
        :reviewed,
        :profile_image,
        :cover_image)
  end
end
