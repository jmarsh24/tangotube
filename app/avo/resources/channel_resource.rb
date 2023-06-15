# frozen_string_literal: true

class ChannelResource < Avo::BaseResource
  self.title = :title
  self.includes = [:videos]
  self.search_query = -> do
    scope.ransack(channel_id_eq: params[:q], m: "or").result(distinct: false)
  end

  grid do
    cover :thumbnail_url, as: :url
    title :title, as: :text
    body :description, as: :text
  end

  field :id, as: :id
  field :thumbnail_url, as: :external_image, hide_on: :show, as_avatar: :rounded
  field :title, as: :text
  field :channel_id, as: :text
  field :imported_at, as: :date_time
  field :reviewed, as: :boolean
  field :active, as: :boolean
  field :videos_count, as: :number do
    model.videos.length
  end
end
