# frozen_string_literal: true

class ChannelResource < Avo::BaseResource
  self.title = :title
  self.search_query = -> do
    scope.ransack(channel_id_eq: params[:q], m: "or").result(distinct: false)
  end

  grid do
    cover :thumbnail_url, as: :url
    title :title, as: :text
    body :description, as: :text
  end

  field :id, as: :id
  field :active, as: :boolean
  field :thumbnail_url, as: :external_image, hide_on: :show, as_avatar: :rounded
  field :title, as: :text, sortable: true do |model|
    model.title.truncate(30)
  end
  field :videos_count, as: :number, read_only: true, sortable: true, hide_on: [:new, :edit]
  field :channel_id, as: :text
  field :reviewed, as: :boolean
  field :imported_at, as: :date_time

  action ToggleActive

  filter ActiveFilter
end
