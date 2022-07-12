module FiltersHelper
  def filtering_params
    params.permit(
      :leader,
      :follower,
      :channel,
      :genre,
      :orchestra,
      :song,
      :hd,
      :event,
      :year,
      :watched,
      :liked,
      :id,
      :query,
      :dancer).to_h.flatten.join("_")
  end
end
