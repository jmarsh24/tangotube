# frozen_string_literal: true

class RemoveTransferredFieldsFromVideos < ActiveRecord::Migration[7.1]
  def up
    remove_column :videos, :youtube_song, :string
    remove_column :videos, :youtube_artist, :string
    remove_column :videos, :acr_cloud_track_name, :string
    remove_column :videos, :acr_cloud_artist_name, :string
    remove_column :videos, :acr_cloud_artist_name_1, :string
    remove_column :videos, :acr_cloud_album_name, :string
    remove_column :videos, :acrid, :string
    remove_column :videos, :isrc, :string
    remove_column :videos, :spotify_artist_name, :string
    remove_column :videos, :spotify_artist_name_1, :string
    remove_column :videos, :spotify_artist_name_2, :string
    remove_column :videos, :spotify_track_name, :string
    remove_column :videos, :spotify_track_id, :string
    remove_column :videos, :spotify_album_name, :string
    remove_column :videos, :spotify_album_id, :string
    remove_column :videos, :youtube_song_id, :string
    remove_column :videos, :performance_date, :datetime
    remove_column :videos, :performance_number, :string
    remove_column :videos, :performance_total_number, :string
    remove_column :videos, :scanned_youtube_music, :string
    remove_column :videos, :scanned_song, :string
    remove_column :videos, :spotify_artist_id, :string
    remove_column :videos, :spotify_artist_id_1, :string
    remove_column :videos, :spotify_artist_id_2, :string
    remove_column :videos, :dislike_count, :integer
    remove_column :videos, :favorite_count, :integer
    remove_column :videos, :comment_count, :integer
  end

  def down
    add_column :videos, :youtube_song, :string
    add_column :videos, :youtube_artist, :string
    add_column :videos, :acr_cloud_track_name, :string
    add_column :videos, :acr_cloud_artist_name, :string
    add_column :videos, :acr_cloud_artist_name_1, :string
    add_column :videos, :acr_cloud_album_name, :string
    add_column :videos, :acrid, :string
    add_column :videos, :isrc, :string
    add_column :videos, :spotify_artist_name, :string
    add_column :videos, :spotify_artist_name_1, :string
    add_column :videos, :spotify_artist_name_2, :string
    add_column :videos, :spotify_track_name, :string
    add_column :videos, :spotify_track_id, :string
    add_column :videos, :spotify_album_name, :string
    add_column :videos, :spotify_album_id, :string
    add_column :videos, :youtube_song_id, :string
    add_column :videos, :performance_date, :datetime
    add_column :videos, :performance_number, :string
    add_column :videos, :performance_total_number, :string
    add_column :videos, :scanned_youtube_music, :string
    add_column :videos, :scanned_song, :string
    add_column :videos, :spotify_artist_id, :string
    add_column :videos, :spotify_artist_id_1, :string
    add_column :videos, :spotify_artist_id_2, :string
    add_column :videos, :dislike_count, :integer
    add_column :videos, :favorite_count, :integer
    add_column :videos, :comment_count, :integer
  end
end
