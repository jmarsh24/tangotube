# frozen_string_literal: true

class MetadataBuilder
  def self.build_metadata(video)
    youtube_metadata = ExternalVideoImport::Youtube::VideoMetadata.new(
      slug: video.youtube_id,
      title: video.title,
      description: video.description,
      upload_date: video.upload_date.to_datetime,
      duration: video.duration,
      tags: video.tags,
      hd: video.hd,
      view_count: video.view_count,
      favorite_count: video.favorite_count,
      comment_count: video.comment_count,
      like_count: video.like_count,
      song: ExternalVideoImport::Youtube::SongMetadata.new(titles: [video.youtube_song], artist: video.youtube_artist),
      thumbnail_url: nil,
      recommended_video_ids: [],
      channel: ExternalVideoImport::Youtube::ChannelMetadata.new(id: video.channel.youtube_slug, title: video.channel.title, thumbnail_url: video.channel.thumbnail_url)
    )

    music_recognition_metadata = ExternalVideoImport::MusicRecognition::Metadata.new(
      code: video.acr_response_code,
      acr_song_title: video.acr_cloud_track_name,
      acr_artist_names: [video.acr_cloud_artist_name, video.acr_cloud_artist_name_1],
      acr_album_name: video.acr_cloud_album_name,
      acr_id: video.acrid,
      isrc: video.isrc,
      genre: nil,
      spotify_artist_names: [video.spotify_artist_name, video.spotify_artist_name_1, video.spotify_artist_name_2],
      spotify_artist_ids: [video.spotify_artist_id, video.spotify_artist_id_1, video.spotify_artist_id_2],
      spotify_track_name: video.spotify_track_name,
      spotify_track_id: video.spotify_track_id,
      spotify_album_name: video.spotify_album_name,
      spotify_album_id: video.spotify_album_id,
      youtube_vid: video.youtube_song_id
    )

    ExternalVideoImport::Metadata.new(
      youtube: youtube_metadata,
      music: music_recognition_metadata
    )
  end
end
