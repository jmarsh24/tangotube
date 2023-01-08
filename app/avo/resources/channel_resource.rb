# frozen_string_literal: true

class ChannelResource < Avo::BaseResource
  self.title = :id
  self.includes = []
  # self.search_query = -> do
  #   scope.ransack(id_eq: params[:q], m: "or").result(distinct: false)
  # end

  field :id, as: :id
  # Fields generated from the model
  field :title, as: :text
  field :channel_id, as: :text
  field :thumbnail_url, as: :text
  field :imported, as: :boolean
  field :imported_videos_count, as: :number
  field :total_videos_count, as: :number
  field :yt_api_pull_count, as: :number
  field :reviewed, as: :boolean
  field :videos_count, as: :number
  field :active, as: :boolean
  field :videos, as: :has_many
  # add fields here
end
