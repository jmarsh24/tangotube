# frozen_string_literal: true

class MetadataBuilder
  def self.build_metadata(video)
    # Create the Youtube metadata object
    youtube_metadata = ExternalVideoImport::Youtube::VideoMetadata.new(
      slug: video.youtube_id,
      title: video.title,
      description: video.description,
      upload_date: video.upload_date,
      duration: video.duration,
      tags: video.tags,
      hd: video.hd,
      view_count: video.view_count,
      favorite_count: video.favorite_count,
      comment_count: video.comment_count,
      like_count: video.like_count,
      song: nil, # Assign song metadata later
      thumbnail_url: nil, # Assign thumbnail metadata later
      recommended_video_ids: [], # You can fetch these from the YouTube API or assign them later
      channel: {
        id: video.channel_id,
        title: nil # You can fetch this from the YouTube API or assign it later
      }
    )

    # Create the Song metadata object
    song_metadata = ExternalVideoImport::Youtube::SongMetadata.new(
      titles: [video.youtube_song],
      song_url: nil, # Assign the song URL later
      artist: video.youtube_artist,
      artist_url: nil, # Assign the artist URL later
      writers: [], # Assign the writers later
      album: video.acr_cloud_album_name
    )

    # Assign the song metadata to the Youtube metadata object
    youtube_metadata.song = song_metadata

    # Create the Music Recognition metadata object
    music_recognition_metadata = ExternalVideoImport::MusicRecognition::Metadata.new(
      code: video.acr_response_code,
      acr_song_title: video.acr_cloud_track_name,
      acr_artist_names: [video.acr_cloud_artist_name, video.acr_cloud_artist_name_1],
      acr_album_name: video.acr_cloud_album_name,
      acr_id: video.acrid,
      isrc: video.isrc,
      genre: nil, # Assign the genre later
      spotify_artist_names: [video.spotify_artist_name, video.spotify_artist_name_1, video.spotify_artist_name_2],
      spotify_track_name: video.spotify_track_name,
      spotify_track_id: video.spotify_track_id,
      spotify_album_name: video.spotify_album_name,
      spotify_album_id: video.spotify_album_id,
      youtube_vid: video.youtube_song_id
    )

    # Create the Metadata object and populate it with the Youtube and Music Recognition metadata
    ExternalVideoImport::Metadata.new(
      youtube: youtube_metadata,
      music: music_recognition_metadata
    )
  end
end
