# == Schema Information
#
# Table name: channels
#
#  id         :bigint           not null, primary key
#  title      :string
#  channel_id :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Channel < ApplicationRecord
  validates :channel_id, presence: true, uniqueness: true
  validates :title, presence: true, uniqueness: true

  has_many :videos
end
