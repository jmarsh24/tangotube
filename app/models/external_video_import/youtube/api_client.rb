# frozen_string_literal: true

module ExternalVideoImport
  module Youtube
    class ApiClient
      def metadata(slug)
        youtube_video = Yt::Video.new(id: slug)

        ApiMetadata.new(
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
          channel: fetch_channel_metadata(youtube_video.channel_id)
        )
      end

      private

      def fetch_channel_metadata(slug)
        youtube_channel = Yt::Channel.new(id: slug)

        ChannelMetadata.new(
          id: youtube_channel.id,
          title: youtube_channel.title,
          thumbnail_url: youtube_channel.thumbnail_url
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
