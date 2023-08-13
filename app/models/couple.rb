# frozen_string_literal: true

# == Schema Information
#
# Table name: couples
#
#  id               :bigint           not null, primary key
#  dancer_id        :bigint           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  partner_id       :bigint
#  videos_count     :integer          default(0), not null
#  slug             :string
#  unique_couple_id :string
#
class Couple < ApplicationRecord
  belongs_to :dancer
  belongs_to :partner, class_name: "Dancer"
  has_many :couple_videos, dependent: :destroy
  has_many :videos, through: :couple_videos

  after_validation :set_slug, only: [:create, :update]
  before_save :set_videos_count
  before_save :order_dancers

  scope :search, ->(name) {
    max_videos = maximum(:videos_count)

    joins(:dancer, :partner)
      .where("dancers.name % :name OR partners_couples.name % :name", name:)
      .select("couples.*, (0.1 * (1 - COALESCE(dancers.name <-> '#{name}', partners_couples.name <-> '#{name}')) + 0.9 * (couples.videos_count::float / #{max_videos})) AS order_value")
      .order("order_value DESC")
  }

  def videos
    Video.where(id: DancerVideo.where(dancer_id: [dancer_id, partner_id])
                                .group(:video_id)
                                .having("count(*) = ?", 2)
                                .select(:video_id))
  end

  def to_param
    "#{id}-#{slug}"
  end

  def dancer_names
    "#{dancer.name} #{partner.name}"
  end

  def dancers
    [dancer, partner]
  end

  private

  def order_dancers
    if dancer_id > partner_id
      self.dancer_id, self.partner_id = partner_id, dancer_id
    end
  end

  def set_videos_count
    self.videos_count = videos.size
  end

  def set_slug
    self.slug = dancer_names.parameterize
  end
end
