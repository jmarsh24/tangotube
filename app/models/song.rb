# == Schema Information
#
# Table name: songs
#
#  id         :bigint           not null, primary key
#  genre      :string
#  title      :string
#  artist     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Song < ApplicationRecord
  validates :genre, presence: true
  validates :title, presence: true
  validates :artist, presence: true

  has_many :videos
end
