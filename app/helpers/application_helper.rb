# frozen_string_literal: true

module ApplicationHelper
  include Shimmer::FileHelper

  def avatar_url_for(user, opts = {})
    size = opts[:size || 32]

    if user.present?
      if user.avatar.attached?
        user.avatar.variant(:thumb)
      elsif user.image?
        user.image
      else
        hash = Digest::MD5.hexdigest(user.email.downcase)
        "https://secure.gravatar.com/avatar/#{hash}.png?s=#{size}"
      end
    else
      image_url("blank_user.png")
    end
  end
end
