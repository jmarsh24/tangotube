# frozen_string_literal: true

class Gravatar
  def initialize(email)
    @digest = Digest::MD5.hexdigest(email.to_s.downcase)
  end

  def id
    @digest
  end

  def url(width:)
    "https://www.gravatar.com/avatar/#{@digest}?d=mm&s=#{width}"
  end
end
