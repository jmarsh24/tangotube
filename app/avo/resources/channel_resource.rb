# frozen_string_literal: true

class ChannelResource < Avo::BaseResource
  self.title = :title
  self.search_query = -> do
    scope.search(params[:q])
  end
  self.resolve_query_scope = ->(model_class:) do
    model_class.most_popular
  end

  grid do
    cover :thumbnail_url, as: :url
    title :title, as: :text
    body :description, as: :text
  end

  field :id, as: :id
  field :link, as: :text do |channel|
    link_to "Channel", main_app.root_path(channel: channel.channel_id), target: "_blank", rel: "noopener"
  end
  field :link, as: :text do |channel|
    link_to "Youtube", "https://www.youtube.com/channel/#{channel.channel_id}", target: "_blank", rel: "noopener"
  end
  field :active, as: :boolean
  field :thumbnail_url, as: :external_image, hide_on: :show, as_avatar: :rounded
  field :title, as: :text, sortable: true do |channel|
    channel.title.truncate(30)
  end
  field :videos_count, as: :number, read_only: true, sortable: true, hide_on: [:new, :edit]
  field :channel_id, as: :text
  field :reviewed, as: :boolean
  field :videos, as: :has_many
  field :events, as: :has_many
  field :dancers, as: :has_many
  field :couples, as: :has_many
  field :songs, as: :has_many
  field :performances, as: :has_many

  action ToggleActive

  filter ActiveFilter
end
