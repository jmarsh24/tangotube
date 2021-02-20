# == Schema Information
#
# Table name: followers
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  reviewed   :boolean
#  nickname   :string
#  first_name :string
#  last_name  :string
#

class Follower < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :videos
  has_many :leader, through: :videos
  has_many :song, through: :videos

  scope :reviewed,     ->   { where(reviewed: true) }
  scope :not_reviewed, ->   { where(reviewed: false) }
  scope :full_name_search, lambda { |query|
                             where('unaccent(name) ILIKE unaccent(:query) OR
                                    unaccent(first_name) ILIKE unaccent(:query) OR
                                    unaccent(last_name) ILIKE unaccent(:query)',
                                    query: "%#{query}%")
                           }

  def full_name
    first_name.present? && last_name.present? ? "#{first_name} #{last_name}" : name
  end
end
