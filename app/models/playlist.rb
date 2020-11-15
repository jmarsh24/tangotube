# == Schema Information
#
# Table name: playlists
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Playlist < ApplicationRecord
  belongs_to :user
  has_many :videos
end
