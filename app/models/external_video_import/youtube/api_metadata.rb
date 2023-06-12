# frozen_string_literal: true

require "store_model"

module ExternalVideoImport
  module Youtube
    class ApiMetadata
      include StoreModel::Model

      attribute :slug, :string
      attribute :title, :string
      attribute :description, :string
      attribute :upload_date, :datetime
      attribute :duration, :integer
      attribute :tags, :array_of_strings, default: -> { [] }
      attribute :hd, :boolean
      attribute :view_count, :integer
      attribute :favorite_count, :integer
      attribute :comment_count, :integer
      attribute :like_count, :integer
      attribute :thumbnail_url, ThumbnailUrl.to_type
      attribute :channel, ChannelMetadata.to_type
    end
  end
end
