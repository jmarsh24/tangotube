# frozen_string_literal: true

class VideoResource < Avo::BaseResource
  self.title = :youtube_id
  self.includes = [:channel, :song, :event, :dancer_videos, :dancers, :performance_video, :performance]
  self.search_query = -> {
    scope.ransack(
      title_cont: params[:q],
      description_cont: params[:q],
      youtube_id_cont: params[:q],
      m: "or"
    ).result(distinct: true)
  }

  self.find_record_method = ->(model_class:, id:, params:) {
    (!id.is_a?(Array) && id.to_i == 0) ? model_class.find_by(youtube_id: id) : model_class.find(id)
  }

  grid do
    cover :thumbnail, as: :file, is_image: true
    title :youtube_id, as: :text do
      model.metadata.youtube.title
    end
    body :description, as: :text do
      model.metadata.youtube.description
    end
  end

  field :id, as: :id
  field :thumbnail, as: :file, is_image: true
  field :youtube_id, as: :text
  field :song, as: :belongs_to
  field :channel, as: :belongs_to
  field :hidden, as: :boolean
  field :featured, as: :boolean
  field :popularity, as: :number
  field :event, as: :belongs_to
  field :click_count, as: :number
  field :metadata, as: :code, language: "javascript", only_on: :edit
  field :metadata, as: :code, language: "javascript" do |model|
    if model.metadata.present?
      JSON.pretty_generate(model.metadata.as_json)
    end
  end
  field :imported_at, as: :date_time
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
