class EventsController < ApplicationController
  before_action :set_event, only: %i[ show edit update destroy ]

  # GET /events
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
          render json: events.map{ |event| { text: event.title, value: event.id } }
      end
    end
  end

  # GET /events/1
  def show
    videos = @event.videos
    @pagy, @videos = pagy(videos, items: 12)
    respond_to do |format|
      format.html # GET
      format.turbo_stream # POST
    end
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  def create
    @event = Event.create( title: params[:event][:title],
                            city: params[:event][:city],
                            country: params[:event][:country]
              )
    if @event.save
      match_event(@event.id)
      redirect_to root_path,
      notice:
      "Event Sucessfully Added"
    else
      redirect_to events_path,
      notice:
      "Event not saved."
    end
  end

  # PATCH/PUT /events/1
  def update
    if @event.update(event_params)
      redirect_to @event, notice: "Event was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /events/1
  def destroy
    @event.destroy
    redirect_to events_url, notice: "Event was successfully destroyed."
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
