# frozen_string_literal: true

module Import
  module Youtube
    class ChannelMetadata
      include StoreModel::Model

      attribute :id, :string
      attribute :title, :string
      attribute :thumbnail_url, :string
    end
  end
end
