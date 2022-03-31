class Clip < ApplicationRecord
  belongs_to :user
  belongs_to :video

  validates :title, presence: true
  validates :start_seconds, presence: true
  validates :end_seconds, presence: true
end
