# frozen_string_literal: true

class WatchResource < Avo::BaseResource
  self.title = :id
  self.includes = []
  # self.search_query = -> do
  #   scope.ransack(id_eq: params[:q], m: "or").result(distinct: false)
  # end

  field :id, as: :id
  # Fields generated from the model
  field :user, as: :belongs_to
  field :video, as: :belongs_to
  field :watched_at, as: :date_time
  # add fields here
end
