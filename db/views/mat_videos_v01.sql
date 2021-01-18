SELECT
  videos.id AS video_id,
  (    to_tsvector('english', coalesce(videos.title, ''))
    || to_tsvector('english', coalesce(videos.description, ''))
    || to_tsvector('english', coalesce(videos.youtube_id, ''))
    || to_tsvector('english', coalesce(videos.youtube_artist, ''))
    || to_tsvector('english', coalesce(videos.youtube_song, ''))
    || to_tsvector('english', coalesce(videos.spotify_track_name, ''))
    || to_tsvector('english', coalesce(videos.spotify_artist_name, ''))
    || to_tsvector('english', coalesce(channels.title, ''))
    || to_tsvector('english', coalesce(channels.channel_id, ''))
    || to_tsvector('english', coalesce(leaders.name, ''))
    || to_tsvector('english', coalesce(leaders.nickname, ''))
    || to_tsvector('english', coalesce(followers.name, ''))
    || to_tsvector('english', coalesce(followers.nickname, ''))
    || to_tsvector('english', coalesce(songs.genre, ''))
    || to_tsvector('english', coalesce(songs.title, ''))
    || to_tsvector('english', coalesce(songs.artist, ''))
  ) AS tsv_document
FROM videos
JOIN channels ON channels.id = videos.channel_id
JOIN followers ON followers.id = videos.follower_id
JOIN leaders ON leaders.id = videos.leader_id
JOIN songs ON songs.id = videos.song_id
GROUP BY channels.id, followers.id, leaders.id, songs.id;
