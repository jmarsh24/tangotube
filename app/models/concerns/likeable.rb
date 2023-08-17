# frozen_string_literal: true

module Likeable
  extend ActiveSupport::Concern

  included do
    has_many :likes, dependent: :destroy
  end

  def likes?(likeable)
    likes.where(likeable:).exists?
  end

  def like_for(likeable)
    likes.find_by(likeable:)
  end
end
