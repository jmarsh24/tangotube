class Couple < ApplicationRecord
  belongs_to :dancer
  belongs_to :partner, class_name: "Dancer"

  after_create :create_inverse, unless: :has_inverse?
  after_destroy :destroy_inverses, if: :has_inverse?
  after_touch :set_videos_count

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
    { dancer_id: partner_id, partner_id: dancer_id}
  end

  def videos
    Video.where(id: DancerVideo.where(dancer_id: [dancer_id, partner_id])
                                .group(:video_id)
                                .having("count(*) = ?", [dancer_id, partner_id].count)
                                .select(:video_id))
  end

  private

  def set_videos_count
    self.videos_count = videos.size
    save
  end
end
