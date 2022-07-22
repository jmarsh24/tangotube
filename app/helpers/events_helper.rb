module EventsHelper
  def event_avatar(event)
    if event.profile_image.attached?
      event.profile_image
    else
      image_url "default_avatar.jpg"
    end
  end

  def event_cover(event)
    if event.cover_image.attached?
      event.cover_image
    else
      "blank_cover.jpg"
    end
  end
end
