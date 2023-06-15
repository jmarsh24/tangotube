# frozen_string_literal: true

class PlaylistVideoResource < Avo::BaseResource
  self.title = :id
  self.includes = []
  self.search_query = -> do
    scope.ransack(id_eq: params[:q], m: "or").result(distinct: false)
  end

  field :id, as: :id

  field :playlist, as: :belongs_to
  field :postiion, as: :number
  field :video, as: :belongs_to
end
