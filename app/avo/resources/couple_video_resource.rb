# frozen_string_literal: true

class CoupleVideoResource < Avo::BaseResource
  self.title = :id
  self.includes = []

  field :id, as: :id
  field :title, as: :text do |model|
    model.video.title
  end
  field :video, as: :belongs_to
  field :couple, as: :belongs_to

  grid do
    cover :video_thumbnail, as: :file do |model|
      model.video.thumbnail
    end
    title :title, as: :text do |model|
      model.video.title
    end
  end
end
