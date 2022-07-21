module CouplesHelper
  def dancer_avatar(dancer_id)
    dancer = Dancer.find(dancer_id)
    if dancer.profile_image.attached?
      dancer.profile_image
    else
      image_url "default_avatar.jpg"
    end
  end

  def dancer_cover(dancer_id)
    dancer = Dancer.find(dancer_id)
    if dancer.cover_image.attached?
      dancer.cover_image
    else
      "blank_cover.jpg"
    end
  end
end
