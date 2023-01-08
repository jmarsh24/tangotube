# frozen_string_literal: true

class PerformanceResource < Avo::BaseResource
  self.title = :id
  self.includes = []
  # self.search_query = -> do
  #   scope.ransack(id_eq: params[:q], m: "or").result(distinct: false)
  # end

  field :id, as: :id
  field :date, as: :date
  field :videos_count, as: :number
  field :slug, as: :text
  field :performance_videos, as: :has_many
  field :videos, as: :has_many, through: :performance_videos
end
