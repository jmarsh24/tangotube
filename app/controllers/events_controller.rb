# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :authorize_event, only: [:new, :create, :edit, :update, :destroy]

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
      format.html
      format.turbo_stream
    end
  end

  def new
    @event = Event.new
  end

  def edit
  end

  def create
    @event = Event.create(event_params)

    if @event.persisted?
      match_event(@event.id)
      redirect_to root_path
    else
      redirect_to events_path
    end
  end

  def update
    if @event.update(event_params)
      redirect_to @event
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    redirect_to events_url
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

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

  def authorize_event
    authorize Event
  end
end
