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
          channel_id: youtube_video.channel_id,
          channel_title: youtube_video.channel_title
        )
      end

      private

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
