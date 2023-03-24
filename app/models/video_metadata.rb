# frozen_string_literal: true

VideoMetadata = Struct.new(:youtube, :acr_cloud, keyword_init: true) do
  def song_attributes
    [youtube.song.titles.join(","),
      youtube.song.artist,
      youtube.song.album,
      acr_cloud.acr_song_title,
      acr_cloud.acr_artist_names.join(","),
      acr_cloud.acr_album_name,
      acr_cloud.spotify_artist_names.join(","),
      acr_cloud.spotify_track_name,
      acr_cloud.spotify_album_name].join(",")
  end
end
