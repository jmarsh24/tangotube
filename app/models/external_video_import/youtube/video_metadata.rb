# frozen_string_literal: true

module ExternalVideoImport
  module Youtube
    class VideoMetadata
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
      attribute :song, SongMetadata.to_type
      attribute :thumbnail_url, ThumbnailUrl.to_type
      attribute :recommended_video_ids, :array_of_strings, default: -> { [] }
      attribute :channel_id, :string
      attribute :channel_title, :string
    end
  end
end
