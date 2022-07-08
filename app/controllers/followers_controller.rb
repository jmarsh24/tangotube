class FollowersController < ApplicationController
  def index
    respond_to do
      |format|
        format.html { @followers = Follower.all.order(:id)}
        format.json do render json: Follower.search(params[:q], order: :name).map { |follower| { text: follower.name, value: follower.id} }
      end
    end
  end

  def create
    @follower = Follower.create(  name: "#{params[:follower][:first_name]} #{params[:follower][:last_name]}",
                                  first_name: params[:follower][:first_name],
                                  last_name: params[:follower][:last_name])
    fetch_new_follower

    redirect_to root_path,
                notice:
                  "Follower Sucessfully Added"
  end

  private

  def fetch_new_follower
    MatchFollowerWorker.perform_async(@follower.id, @follower.full_name)
  end
end
