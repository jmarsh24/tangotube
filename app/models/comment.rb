class Comment < ApplicationRecord
  belongs_to :user, optional: false
  belongs_to :video, optional: false

  validates :body, presence: true
end
