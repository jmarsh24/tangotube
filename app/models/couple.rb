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

  scope :search, ->(query) {
    normalized_query = TextNormalizer.normalize(query)
    quoted_query = ActiveRecord::Base.connection.quote_string(normalized_query)

    joins(:dancer, :partner)
      .select("couples.*,((couples.videos_count / 1000) + ( (word_similarity(dancers.name, '#{quoted_query}') + word_similarity(partners_couples.name, '#{quoted_query}')) / 2 * 0.3)) as score")
      .where("dancers.name <% :query OR partners_couples.name <% :query", query: normalized_query)
      .order("score DESC")
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
