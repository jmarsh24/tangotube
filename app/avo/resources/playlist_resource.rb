# frozen_string_literal: true

class PlaylistResource < Avo::BaseResource
  self.title = :id
  self.includes = []
  # self.search_query = -> do
  #   scope.ransack(id_eq: params[:q], m: "or").result(distinct: false)
  # end

  field :id, as: :id

  field :slug, as: :text
  field :title, as: :text
  field :description, as: :textarea
  field :channel_title, as: :text
  field :channel_id, as: :text
  field :video_count, as: :text
  field :imported, as: :boolean
  field :videos_id, as: :number
  field :user_id, as: :number
  field :reviewed, as: :boolean
  field :videos, as: :has_many
  field :user, as: :belongs_to
  field :playlist_videos, as: :has_many
end
