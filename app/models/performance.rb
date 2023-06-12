# frozen_string_literal: true

# == Schema Information
#
# Table name: performances
#
#  id           :bigint           not null, primary key
#  date         :date
#  videos_count :integer
#  slug         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Performance < ApplicationRecord
  has_many :performance_videos, dependent: :destroy
  has_many :videos, through: :performance_videos
  has_many :dancers, through: :videos
  has_many :channels, through: :videos
end
