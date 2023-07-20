# frozen_string_literal: true

class PerformanceResource < Avo::BaseResource
  self.title = :id
  self.includes = []
  # self.search_query = -> do
  #   scope.search(params[:q])
  # end

  field :id, as: :id
  field :date, as: :date
  field :slug, as: :text
  field :performance_videos, as: :has_many
  field :videos, as: :has_many
  field :dancers, as: :has_many
  field :videos_count, read_only: true, sortable: true, hide_on: [:new, :edit]
  field :dancers_count, as: :number do
    model.dancers.length
  end
  field :dancers, as: :text do |model|
    model.dancers.map(&:name).join(", ")
  end
  field :couples, as: :text do |model|
    model.dancers.map(&:name).join(" & ")
  end
end
