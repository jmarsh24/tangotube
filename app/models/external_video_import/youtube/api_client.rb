# frozen_string_literal: true

module ExternalVideoImport
  module Youtube
    class ApiClient
      Metadata = Data.define(:slug, :title, :description, :upload_date, :duration, :tags,
        :hd, :view_count, :favorite_count, :comment_count,
        :like_count, :thumbnail_url, :channel).freeze

      def metadata(slug)
        youtube_video = Yt::Video.new(id: slug)

        Metadata.new(
          slug:,
          title: youtube_video.title,
          description: youtube_video.description,
          upload_date: youtube_video.published_at,
          duration: youtube_video.duration,
          tags: youtube_video.tags,
          hd: youtube_video.hd?,
          view_count: youtube_video.view_count,
          favorite_count: youtube_video.favorite_count,
          comment_count: youtube_video.comment_count,
          like_count: youtube_video.like_count,
          thumbnail_url: extract_thumbnail_url(youtube_video),
          channel: extract_channel_metadata(youtube_video.channel_id)
        )
      end

      private

      def extract_channel_metadata(slug)
        youtube_channel = Yt::Channel.new(id: slug)

        ChannelMetadata.new(
          id: youtube_channel.id,
          title: youtube_channel.title,
          description: youtube_channel.description,
          published_at: youtube_channel.published_at,
          thumbnail_url: youtube_channel.thumbnail_url,
          view_count: youtube_channel.view_count,
          video_count: youtube_channel.video_count,
          videos: youtube_channel.related_playlists.first&.playlist_items&.map(&:video_id) || youtube_channel.videos.map(&:id),
          playlists: youtube_channel.playlists.map(&:id),
          related_playlists: youtube_channel.related_playlists.map(&:id),
          subscriber_count: youtube_channel.subscriber_count,
          privacy_status: youtube_channel.privacy_status
        )
      end

      def extract_thumbnail_url(youtube_video)
        ThumbnailUrl.new(
          default: youtube_video.thumbnail_url(:default),
          medium: youtube_video.thumbnail_url(:medium),
          high: youtube_video.thumbnail_url(:high),
          standard: youtube_video.thumbnail_url(:standard),
          maxres: youtube_video.thumbnail_url(:maxres)
        )
      end
    end
  end
end
