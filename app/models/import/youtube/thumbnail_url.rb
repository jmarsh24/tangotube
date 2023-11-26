# frozen_string_literal: true

module Import
  module Youtube
    class ThumbnailUrl
      include StoreModel::Model

      attribute :default, :string
      attribute :medium, :string
      attribute :high, :string
      attribute :standard, :string
      attribute :maxres, :string

      def highest_resolution
        maxres || standard || high || medium || default
      end
    end
  end
end
