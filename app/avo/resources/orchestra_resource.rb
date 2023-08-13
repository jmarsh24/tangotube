# frozen_string_literal: true

class OrchestraResource < Avo::BaseResource
  self.title = :name
  self.includes = []
  self.search_query = -> do
    scope.search(params[:q])
  end
  self.resolve_query_scope = ->(model_class:) do
    model_class.most_popular
  end

  field :id, as: :id

  field :profile_image, as: :file, is_image: true, as_avatar: :circle
  field :name, as: :text
  field :bio, as: :textarea
  field :slug, as: :text
  field :videos_count, as: :number, sortable: true
  field :songs_count, as: :number
  field :cover_image, as: :file, is_image: true, hide_on: [:index]
  field :songs, as: :has_many
  field :videos, as: :has_many, through: :songs
  field :dancers, as: :has_many, through: :videos
  field :couples, as: :has_many, through: :videos
end
