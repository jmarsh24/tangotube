# frozen_string_literal: true

class EventResource < Avo::BaseResource
  self.title = :title
  self.includes = [:videos]
  self.search_query = -> {
    scope.ransack(
      title_cont: params[:q],
      city_cont: params[:q],
      country_cont: params[:q],
      m: "or"
    ).result(distinct: true)
  }

  self.find_record_method = ->(model_class:, id:, params:) {
    (!id.is_a?(Array) && id.to_i == 0) ? model_class.find_by(slug: id) : model_class.find(id)
  }

  field :id, as: :id
  field :title, as: :text, required: true
  field :videos_count, as: :number do
    model.videos.length
  end
  field :dancers, as: :has_many
  field :city, as: :text, required: true
  field :country, as: :text, required: true
  field :category, as: :text
  field :start_date, as: :date
  field :end_date, as: :date
  field :active, as: :boolean
  field :reviewed, as: :boolean
  field :slug, as: :text
  field :profile_image, as: :file, is_image: true, is_avatar: true
  field :cover_image, as: :file, is_image: true, is_avatar: true
  field :videos, as: :has_many
  field :created_at, as: :date_time
  field :updated_at, as: :date_time
end
