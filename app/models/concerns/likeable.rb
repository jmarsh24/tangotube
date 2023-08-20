# frozen_string_literal: true

module Likeable
  extend ActiveSupport::Concern

  def likes?(likeable)
    likes.where(likeable:).exists?
  end

  def like_for(likeable)
    likes.find_by(likeable:)
  end
end
