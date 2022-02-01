class LeadersController < ApplicationController
  def index
    respond_to do
      |format|
        format.html { @leaders = Leader.all.order(:id)}
        format.json { render json: Leader.full_name_search(params[:q])
                                          .distinct
                                          .order(:name)
                                          .pluck(:name, :id)}
    end
  end

  def create
    @leader = Leader.create(  name: "#{params[:leader][:first_name]} #{params[:leader][:last_name]}",
                              first_name: params[:leader][:first_name],
                              last_name: params[:leader][:last_name])
    fetch_new_leader

    redirect_to root_path,
                notice:
                  "Leader Sucessfully Added"
  end

  private

  def fetch_new_leader
    MatchLeaderWorker.perform_async(@leader.id, @leader.full_name)
  end
end
