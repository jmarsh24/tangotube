# frozen_string_literal: true

class PerformanceResource < Avo::BaseResource
  self.title = :id
  self.includes = [:videos, :performance_videos, :dancers]
  self.search_query = -> do
    scope.ransack(id_eq: params[:q], m: "or").result(distinct: false)
  end

  field :id, as: :id
  field :date, as: :date
  field :slug, as: :text
  field :performance_videos, as: :has_many
  field :videos, as: :has_many
  field :dancers, as: :has_many
  field :videos_count, as: :number do
    model.performance_videos.length
  end
  field :dancers_count, as: :number do
    model.dancers.length
  end
  field :dancers, as: :text do |model|
    model.dancers.map(&:name).join(" & ")
  end
end
