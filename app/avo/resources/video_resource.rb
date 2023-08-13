# frozen_string_literal: true

class VideoResource < Avo::BaseResource
  self.title = :title
  self.includes = [:channel, :song, :event, :video_score, :dancers, :dancer_videos]
  self.search_query = -> { scope.search(params[:q]) }
  self.resolve_query_scope = ->(model_class:) do
    model_class.trending_1
  end

  self.find_record_method = ->(model_class:, id:, params:) {
    (!id.is_a?(Array) && id.to_i == 0) ? model_class.find_by(youtube_id: id) : model_class.find(id)
  }

  grid do
    cover :thumbnail, as: :file, is_image: true
    title :youtube_id, as: :text do
      model.title
    end
    body :description, as: :text do
      model.description
    end
  end

  field :id, as: :id
  field :link, as: :text do |video|
    link_to "Video", main_app.watch_path(v: video.youtube_id), target: "_blank", rel: "noopener"
  end
  field :link, as: :text do |video|
    link_to "Youtube", "https://www.youtube.com/watch?v=#{video.youtube_id}", target: "_blank", rel: "noopener"
  end
  field :thumbnail, as: :file, is_image: true
  field :song, as: :belongs_to
  field :channel, as: :belongs_to
  field :hidden, as: :boolean
  field :featured, as: :boolean
  field :event, as: :belongs_to
  field :score_1, as: :number do |model|
    format("%.3f", model.video_score.score_1)
  end
  field :score_2, as: :number do |model|
    format("%.3f", model.video_score.score_2)
  end
  field :score_3, as: :number do |model|
    format("%.3f", model.video_score.score_3)
  end
  field :score_4, as: :number do |model|
    format("%.3f", model.video_score.score_4)
  end
  field :score_5, as: :number do |model|
    format("%.3f", model.video_score.score_5)
  end
  field :metadata, as: :code, language: "javascript", only_on: :edit
  field :metadata, as: :code, language: "javascript" do |model|
    if model.metadata.present?
      JSON.pretty_generate(model.metadata.as_json)
    end
  end
  field :upload_date, as: :date
  field :metadata_updated_at, as: :date_time, hide_on: [:new, :edit, :index]
  field :created_at, as: :date_time, hide_on: [:new, :edit, :index]
  field :updated_at, as: :date_time, hide_on: [:new, :edit, :index]

  action ToggleHidden
  action ToggleFeatured

  filter FeaturedFilter
  filter HiddenFilter
end
