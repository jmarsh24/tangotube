module DancersHelper
  def dancer_avatar(dancer_id)
    dancer = Dancer.find(dancer_id)
    if dancer.profile_image.attached?
        image_tag dancer.profile_image
    else
        image_url "default_avatar.jpg"
    end
end
end
