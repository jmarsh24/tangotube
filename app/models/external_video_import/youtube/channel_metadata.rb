# frozen_string_literal: true

module ExternalVideoImport
  module Youtube
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
      attribute :videos, :array_of_strings, default: -> { [] }
      attribute :playlists, :array_of_strings, default: -> { [] }
      attribute :related_playlists, :array_of_strings, default: -> { [] }
      attribute :subscribed_channels, :array_of_strings, default: -> { [] }
      attribute :privacy_status, :string
    end
  end
end
