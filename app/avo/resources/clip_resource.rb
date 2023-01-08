# frozen_string_literal: true

class ClipResource < Avo::BaseResource
  self.title = :id
  self.includes = [:video]
  # self.search_query = -> do
  #   scope.ransack(id_eq: params[:q], m: "or").result(distinct: false)
  # end

  grid do
    cover :giphy_url, as: :external_image, link_to_resource: true
    title :title, as: :text
    body :video, as: :tags
  end

  field :id, as: :id, link_to_resource: true
  field :giphy_url, as: :external_image, link_to_resource: true
  field :start_seconds, as: :number
  field :end_seconds, as: :number
  field :title, as: :text
  field :playback_rate, as: :number
  field :user_id, as: :number
  field :giphy_id, as: :text
  field :user, as: :belongs_to
  field :video, as: :belongs_to
  field :tags, as: :tags
end
