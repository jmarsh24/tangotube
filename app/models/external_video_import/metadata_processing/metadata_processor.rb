# frozen_string_literal: true

module ExternalVideoImport
  module MetadataProcessing
    class MetadataProcessor
      def initialize(song_matcher: SongMatcher.new, channel_matcher: ChannelMatcher.new, dancer_matcher: DancerMatcher.new, couple_matcher: CoupleMatcher.new)
        @song_matcher = song_matcher
        @channel_matcher = channel_matcher
        @dancer_matcher = dancer_matcher
        @couple_matcher = couple_matcher
      end

      def process(metadata)
        dancers = @dancer_matcher.match(metadata_fields: metadata.youtube.title)
        couples = @couple_matcher.match_or_create(dancers:)

        {
          youtube_id: metadata.youtube.slug,
          channel: @channel_matcher.match_or_create(channel_metadata: metadata.youtube.channel),
          song: @song_matcher.match_or_create(metadata_fields: metadata.searchable_music_fields, artist_fields: metadata.searchable_artist_names, title_fields: metadata.searchable_song_titles, genre_fields: metadata.genre_fields).first,
          dancers:,
          couples:
        }
      end
    end
  end
end
