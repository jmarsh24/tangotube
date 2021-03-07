module Reviewable
  extend ActiveSupport::Concern
  included do
    scope :reviewed, -> { where(reviewed: true) }
    scope :not_reviewed, -> { where(reviewed: false) }
  end
end
