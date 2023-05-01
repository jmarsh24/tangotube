# frozen_string_literal: true

module ExternalVideoImport
  module MetadataProcessing
    class MetadataProcessor
      def initialize(song_matcher: SongMatcher.new, channel_matcher: ChannelMatcher.new, dancer_matcher: DancerMatcher.new, couple_matcher: CoupleMatcher.new, performance_matcher: PerformanceMatcher.new)
        @song_matcher = song_matcher
        @channel_matcher = channel_matcher
        @dancer_matcher = dancer_matcher
        @couple_matcher = couple_matcher
        @performance_matcher = performance_matcher
      end

      def process(metadata)
        dancers = @dancer_matcher.match(metadata_fields: metadata.youtube.title)
        couples = @couple_matcher.match_or_create(dancers: dancers)
        performance = @performance_matcher.parse(text: "#{metadata.youtube.title} #{metadata.youtube.description}")

        {
          youtube_id: metadata.youtube.slug,
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
          channel: @channel_matcher.match_or_create(channel_metadata: metadata.youtube.channel),
          song: @song_matcher.match_or_create(metadata_fields: metadata.searchable_music_fields, artist_fields: metadata.searchable_artist_names, title_fields: metadata.searchable_song_titles, genre_fields: metadata.genre_fields).first,
          dancers: dancers,
          couples: couples,
          performance_number: performance&.position,
          performance_total_number: performance&.total
        }
      end
    end
  end
end
