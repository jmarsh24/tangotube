# frozen_string_literal: true

class VideoResource < Avo::BaseResource
  self.title = :youtube_id
  self.includes = [:channel, :song, :event]
  self.search_query = -> { scope.search(params[:q]) }

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
  field :metadata, as: :code, language: "javascript", only_on: :edit
  field :metadata, as: :code, language: "javascript" do |model|
    if model.metadata.present?
      JSON.pretty_generate(model.metadata.as_json)
    end
  end
  field :upload_date, as: :date
  field :metadata_updated_at, as: :date_time
  field :dancer_videos, as: :has_many
  field :dancers, as: :has_many
  field :created_at, as: :date_time
  field :updated_at, as: :date_time

  action ToggleHidden
  action ToggleFeatured

  filter FeaturedFilter
  filter HiddenFilter
end
