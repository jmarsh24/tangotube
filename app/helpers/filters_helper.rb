module FiltersHelper
  def filtering_params
    params.permit(:genre, :leader, :follower, :orchestra, :year).to_h.flatten.join("_")
  end
end
