# frozen_string_literal: true

module ExternalVideoImport
  module MusicRecognition
    class AcrCloud
      HTTP_METHOD = "POST"
      HTTP_URI = "/v1/identify"
      DATA_TYPE = "audio"
      SIGNATURE_VERSION = "1"
      REQ_URL = "http://identify-eu-west-1.acrcloud.com/v1/identify"

      def analyze(file:)
        data = JSON.parse(HTTParty.post(REQ_URL, body: body(file)), symbolize_names: true)
        map_metadata(data)
      end

      private

      def body(file)
        {
          sample: file,
          access_key: Config.acr_cloud_access_key!,
          data_type: DATA_TYPE,
          signature_version: SIGNATURE_VERSION,
          signature: signature,
          sample_bytes: file.size,
          timestamp: timestamp
        }
      end

      def map_metadata(data)
        MusicRecognizer::Metadata.new(
          code: data.dig(:status, :code),
          message: data.dig(:status, :msg),
          acr_song_title: data.dig(:metadata, :music, 0, :title),
          acr_artist_names: data.dig(:metadata, :music, 0, :artists)&.map { |e| e[:name] } || [],
          acr_album_name: data.dig(:metadata, :music, 0, :album, :name),
          acr_id: data.dig(:metadata, :music, 0, :acrid),
          isrc: data.dig(:metadata, :music, 0, :external_ids, :isrc),
          genre: data.dig(:metadata, :music, 0, :genres, 0, :name),
          spotify_artist_names: data.dig(:metadata, :music, 0, :external_metadata, :spotify, :artists)&.map { |e| e[:name] } || [],
          spotify_track_name: data.dig(:metadata, :music, 0, :external_metadata, :spotify, :track, :name),
          spotify_track_id: data.dig(:metadata, :music, 0, :external_metadata, :spotify, :track, :id),
          spotify_album_name: data.dig(:metadata, :music, 0, :external_metadata, :spotify, :album, :name),
          spotify_album_id: data.dig(:metadata, :music, 0, :external_metadata, :spotify, :album, :id),
          youtube_vid: data.dig(:metadata, :music, 0, :external_metadata, :youtube, :vid)
        )
      end

      def signature
        Base64.encode64(OpenSSL::HMAC.digest(digest, Config.acr_cloud_secret_key!, unsigned_string)).strip
      end

      def unsigned_string
        "#{HTTP_METHOD}\n#{HTTP_URI}\n#{Config.acr_cloud_access_key!}\n#{DATA_TYPE}\n#{SIGNATURE_VERSION}\n#{timestamp}"
      end

      def digest
        OpenSSL::Digest.new("sha1")
      end

      def timestamp
        Time.now.utc.to_i.to_s
      end
    end
  end
end
