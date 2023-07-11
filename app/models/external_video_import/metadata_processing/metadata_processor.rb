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
        dancers = @dancer_matcher.match(video_title: metadata.youtube.title)
        log_matched_dancers(dancers)
        couples = @couple_matcher.match_or_create(dancers:)
        log_matched_couples(couples)

        song = match_song(metadata)
        log_matched_song(song)

        video_data = {
          youtube_id: metadata.youtube.slug,
          upload_date: metadata.youtube.upload_date.to_datetime,
          upload_date_year: metadata.youtube.upload_date.year,
          title: metadata.youtube.title,
          description: metadata.youtube.description,
          channel: @channel_matcher.match_or_create(channel_metadata: metadata.youtube.channel),
          song:,
          couples:,
          acr_response_code: metadata.music.code,
          duration: metadata.youtube.duration,
          hd: metadata.youtube.hd,
          youtube_view_count: metadata.youtube.view_count,
          youtube_like_count: metadata.youtube.like_count,
          youtube_tags: metadata.youtube.tags
        }
        assign_dancers_with_roles(video_data, dancers)
        video_data
      end

      private

      def match_song(metadata)
        song = @song_matcher.match(
          video_title: metadata.youtube.title,
          video_description: metadata.youtube.description,
          song_titles: metadata.song_titles,
          song_artists: metadata.artist_names,
          song_albums: metadata.album_names
        )
        if song && song.spotify_track_id.blank?
          song.spotify_track_id = metadata.music.spotify_track_id
          song.save!
        end
        song
      end

      def assign_dancers_with_roles(video_data, dancers)
        video_data[:dancer_videos] = dancers.map do |dancer|
          role = determine_dancer_role(dancer)
          DancerVideo.new(dancer:, role:)
        end
      end

      def determine_dancer_role(dancer)
        (dancer.gender == "male") ? "leader" : "follower"
      end

      def log_matched_dancers(dancers)
        if dancers.any?
          Rails.logger.info "Matched dancers:"
          dancers.each { |dancer| Rails.logger.info "- #{dancer.name}" }
        else
          Rails.logger.info "No dancers matched."
        end
      end

      def log_matched_couples(couple)
        if couple.present?
          Rails.logger.info "Matched couples: #{couple.dancers.map(&:name).join(" & ")}"
        else
          Rails.logger.info "No couples matched."
        end
      end

      def log_matched_song(song)
        if song.present?
          Rails.logger.info "Matched song: #{song.title} - #{song.artist}"
        else
          Rails.logger.info "No song matched."
        end
      end
    end
  end
end
