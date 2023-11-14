# frozen_string_literal: true

module ExternalVideoImport
  module MetadataProcessing
    class ChannelMatcher
      def initialize(thumbnail_attacher = ThumbnailAttacher.new)
        @thumbnail_attacher = thumbnail_attacher
      end

      def match_or_create(channel_metadata:)
        match_channel(channel_metadata) || create_channel(channel_metadata)
      end

      private

      def match_channel(channel_metadata)
        ::Channel.find_by(youtube_slug: channel_metadata.id)
      end

      def create_channel(channel_metadata)
        channel = ::Channel.create!(
          youtube_slug: channel_metadata.id,
          title: channel_metadata.title,
          thumbnail_url: channel_metadata.thumbnail_url
        )
        attach_avatar_thumbnail(channel, channel_metadata.thumbnail_url)
        channel.sync_videos(use_music_recognizer: true)
        channel
      end

      def attach_avatar_thumbnail(channel, thumbnail_url)
        return if thumbnail_url.blank?

        @thumbnail_attacher.attach_thumbnail(channel, thumbnail_url)
      end
    end
  end
end
