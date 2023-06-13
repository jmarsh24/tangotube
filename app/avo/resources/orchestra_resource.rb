# frozen_string_literal: true

class OrchestraResource < Avo::BaseResource
  self.title = :name
  self.includes = []
  self.search_query = -> do
    scope.ransack(id_eq: params[:q], m: "or").result(distinct: false)
  end

  field :id, as: :id

  field :name, as: :text
  field :bio, as: :textarea
  field :slug, as: :text
  field :videos_count, as: :number
  field :songs_count, as: :number
  field :profile_image, as: :file
  field :cover_image, as: :file
  field :songs, as: :has_many
  field :videos, as: :has_many, through: :songs
  field :dancers, as: :has_many, through: :videos
  field :couples, as: :has_many, through: :videos
end
