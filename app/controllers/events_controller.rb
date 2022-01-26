class EventsController < ApplicationController
  def index
    respond_to do
      |format|
        format.html { @events = Event.all.order(:id)}
        format.json { render json: @events =  Event.title_search(params[:q])
                                                    .distinct
                                                    .order(:title)
                                                    .pluck(:title,
                                                            :id)}
    end
  end

  def create
    @event = Event.create(  title: params[:event][:title],
                            city: params[:event][:city],
                            country: params[:event][:country]
                            )
    if @event.save
      redirect_to root_path,
                  notice:
                    "Event Sucessfully Added"
    else
      redirect_to events_path,
      notice:
        "Event not saved."
    end
  end
end
