# frozen_string_literal: true

class PatreonEventResource < Avo::BaseResource
  self.title = :id
  self.includes = []
  # self.search_query = -> do
  #   scope.ransack(id_eq: params[:q], m: "or").result(distinct: false)
  # end

  field :id, as: :id
  # Fields generated from the model
  field :event_type, as: :text
  field :data, as: :text
  # add fields here
end
