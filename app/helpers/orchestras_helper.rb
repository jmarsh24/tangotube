# frozen_string_literal: true

module OrchestrasHelper
  def orchestra_avatar(orchestra_id)
    orchestra = Orchestra.find(orchestra_id)
    if orchestra.profile_image.attached?
      orchestra.profile_image
    else
      image_url "default_avatar.jpg"
    end
  end

  def orchestra_cover(orchestra_id)
    orchestra = Orchestra.find(orchestra_id)
    if orchestra.cover_image.attached?
      orchestra.cover_image
    else
      "blank_cover.jpg"
    end
  end

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
      :dancer
    ).to_h.flatten.join("_")
  end
end
