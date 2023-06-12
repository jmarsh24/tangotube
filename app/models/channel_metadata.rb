# frozen_string_literal: true

class ChannelMetadata
  include StoreModel::Model

  attribute :id, :string
  attribute :title, :string
  attribute :description, :string
  attribute :published_at, :datetime
  attribute :thumbnail_url, :string
  attribute :view_count, :integer
  attribute :video_count, :integer
  attribute :subscriber_count, :integer
  attribute :content_owner, :string
  attribute :video_ids, :array_of_strings, default: -> { [] }
  attribute :playlist_ids, :array_of_strings, default: -> { [] }
  attribute :related_playlist_ids, :array_of_strings, default: -> { [] }
  attribute :privacy_status, :string
end
