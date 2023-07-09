# frozen_string_literal: true

class PerformanceVideoResource < Avo::BaseResource
  self.title = :id
  self.includes = [:video, :performance]
  self.search_query = -> do
    scope.ransack(id_eq: params[:q], m: "or").result(distinct: false)
  end

  field :id, as: :id

  field :video_thumbnail, as: :file, is_image: true, is_avatar: true do
    model.video.thumbnail
  end
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
