# frozen_string_literal: true

class PerformanceVideoResource < Avo::BaseResource
  self.title = :id
  self.includes = [:video, :performance]

  field :id, as: :id
  field :title, as: :text do |model|
    model.video.title
  end
  field :performance_id, as: :number
  field :position, as: :number
  field :video, as: :belongs_to
  field :performance, as: :belongs_to

  grid do
    cover :video_thumbnail, as: :file do |model|
      model.video.thumbnail
    end
    title :title, as: :text do |model|
      model.video.title
    end
    body :position, as: :text do |model|
      "Position: #{model.position} / #{model.performance.performance_videos.length}"
    end
  end
end
