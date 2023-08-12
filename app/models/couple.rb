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

  scope :search, ->(search_term) {
                   max_videos_count = Dancer.maximum(:videos_count).to_f
                   terms = TextNormalizer.normalize(search_term).split

                   dancer_conditions = terms.map { "dancers.name % ?" }.join(" OR ")
                   partner_conditions = terms.map { "partners_dancers.name % ?" }.join(" OR ")

                   where_conditions = "(#{dancer_conditions}) AND (#{partner_conditions})"

                   order_sql = <<-SQL.squish
    0.8 * (1 - (COALESCE(dancers.name, partners_dancers.name) <-> '#{search_term}'))
    + 0.2 * (COALESCE(dancers.videos_count, partners_dancers.videos_count)::float / #{max_videos_count}) DESC
                   SQL

                   joins(:dancer)
                     .joins("INNER JOIN dancers partners_dancers ON partners_dancers.id = couples.partner_id")
                     .where(where_conditions, *(terms * 2))
                     .order(Arel.sql(order_sql))
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
