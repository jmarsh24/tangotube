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
  before_save :set_unique_couple_id
  after_create :create_inverse, unless: :has_inverse?
  after_destroy :destroy_inverses, if: :has_inverse?

  def create_inverse
    self.class.create(inverse_couple_options)
  end

  def destroy_inverses
    inverses.destroy_all
  end

  def has_inverse?
    self.class.exists?(inverse_couple_options)
  end

  def inverses
    self.class.where(inverse_couple_options)
  end

  def inverse_couple_options
    {dancer_id: partner_id, partner_id: dancer_id}
  end

  def videos
    Video.where(id: DancerVideo.where(dancer_id: [dancer_id, partner_id])
                                .group(:video_id)
                                .having("count(*) = ?", 2)
                                .select(:video_id))
  end

  def to_param
    "#{id}-#{slug}"
  end

  def couple_names
    "#{dancer.name} #{partner.name}"
  end

  private

  def set_videos_count
    self.videos_count = videos.size
  end

  def set_slug
    self.slug = couple_names.parameterize
  end

  def set_unique_couple_id
    self.unique_couple_id = [dancer_id, partner_id].sort.map(&:to_s).join("|")
  end
end
