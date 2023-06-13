class PerformanceVideoResource < Avo::BaseResource
  self.title = :id
  self.includes = [:video, :performance]
  self.search_query = -> do
    scope.ransack(id_eq: params[:q], m: "or").result(distinct: false)
  end

  field :id, as: :id

  field :video_id, as: :number
  field :performance_id, as: :number
  field :position, as: :number
  field :video, as: :belongs_to
  field :performance, as: :belongs_to
end
