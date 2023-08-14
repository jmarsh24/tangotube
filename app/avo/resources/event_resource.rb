# frozen_string_literal: true

class EventResource < Avo::BaseResource
  self.title = :title
  self.includes = []
  self.search_query = -> {
    scope.ransack(
      title_cont: params[:q],
      city_cont: params[:q],
      country_cont: params[:q],
      m: "or"
    ).result(distinct: true)
  }
  self.resolve_query_scope = ->(model_class:) do
    model_class.most_popular
  end

  self.find_record_method = ->(model_class:, id:, params:) {
    (!id.is_a?(Array) && id.to_i == 0) ? model_class.find_by(slug: id) : model_class.find(id)
  }

  field :id, as: :id
  field :profile_image, as: :file, is_image: true, as_avatar: :circle
  field :title, as: :text, required: true
  field :videos_count, as: :number, only_on: :index, sortable: true, read_only: true
  field :videos, as: :has_many
  field :dancers, as: :has_many, through: :videos
  field :city, as: :text, required: true
  field :country, as: :text, required: true
  field :category, as: :text
  field :start_date, as: :date
  field :end_date, as: :date
  field :active, as: :boolean
  field :reviewed, as: :boolean
  field :slug, as: :text
  field :cover_image, as: :file, is_image: true, hide_on: [:index]
  field :videos, as: :has_many
  field :created_at, as: :date_time
  field :updated_at, as: :date_time
end
