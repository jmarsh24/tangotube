# frozen_string_literal: true

module ExternalVideoImport
  class Importer
    def initialize(song_matcher: SongMatcher.new, crawler: Crawler.new)
      @song_matcher = song_matcher
      @video_crawler = video_crawler
    end

    def import(youtube_slug)
      metadata = @video_crawler.crawl(youtube_slug)
      Video.transaction do
        ::Video.create!(
          youtube_slug:,
          title: metadata.youtube.title,
          description: metadata.youtube.description,
          upload_date: metadata.youtube.upload_date,
          duration: metadata.youtube.duration,
          tags: metadata.youtube.tags,
          hd: metadata.youtube.hd,
          view_count: metadata.youtube.view_count,
          favorite_count: metadata.youtube.favorite_count,
          comment_count: metadata.youtube.comment_count,
          like_count: metadata.youtube.like_count,
          thumbnail_url: metadata.youtube.thumbnail_url,
          recommended_video_ids: metadata.youtube.recommended_video_ids,
          # channel: channel,
          # dancers: dancers,
          # couple: couple,
          # performance: performance,
          song: @song_matcher.match(song_metadata)
        )
      end
    end
  end
end
