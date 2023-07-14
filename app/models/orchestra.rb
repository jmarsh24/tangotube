# frozen_string_literal: true

# == Schema Information
#
# Table name: orchestras
#
#  id           :bigint           not null, primary key
#  name         :string           not null
#  bio          :text
#  slug         :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  videos_count :integer          default(0), not null
#  songs_count  :integer          default(0), not null
#  search_term  :string
#
class Orchestra < ApplicationRecord
  has_many :songs, dependent: :destroy
  has_many :videos, through: :songs
  has_many :dancers, through: :videos
  has_many :couples, through: :videos

  validates :name, presence: true, uniqueness: true

  has_one_attached :profile_image
  has_one_attached :cover_image

  after_validation :set_slug, only: [:create, :update]

  scope :search, ->(name) {
                   quoted_name = ActiveRecord::Base.connection.quote_string(name)
                   select("*, similarity(name, '#{quoted_name}') + (videos_count / 1000) as score")
                     .where("? % name", name)
                     .order("score DESC")
                 }

  def to_param
    "#{id}-#{slug}"
  end

  private

  def set_slug
    self.slug = name.parameterize
  end
end
