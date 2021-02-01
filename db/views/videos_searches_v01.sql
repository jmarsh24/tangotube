SELECT
  videos.id AS video_id,
  (    to_tsvector('english', unaccent(coalesce(videos.title, '')))
    || to_tsvector('english', unaccent(coalesce(videos.description, '')))
    || to_tsvector('english', unaccent(coalesce(videos.youtube_id, '')))
    || to_tsvector('english', unaccent(coalesce(videos.youtube_artist, '')))
    || to_tsvector('english', unaccent(coalesce(videos.youtube_song, '')))
    || to_tsvector('english', unaccent(coalesce(videos.spotify_track_name, '')))
    || to_tsvector('english', unaccent(coalesce(videos.spotify_artist_name, '')))
    || to_tsvector('english', unaccent(coalesce(channels.title, '')))
    || to_tsvector('english', unaccent(coalesce(channels.channel_id, '')))
    || to_tsvector('english', unaccent(coalesce(leaders.name, '')))
    || to_tsvector('english', unaccent(coalesce(leaders.nickname, '')))
    || to_tsvector('english', unaccent(coalesce(followers.name, '')))
    || to_tsvector('english', unaccent(coalesce(followers.nickname, '')))
    || to_tsvector('english', unaccent(coalesce(songs.genre, '')))
    || to_tsvector('english', unaccent(coalesce(songs.title, '')))
    || to_tsvector('english', unaccent(coalesce(songs.artist, '')))
  ) AS tsv_document
FROM videos
LEFT OUTER JOIN  channels ON channels.id = videos.channel_id
LEFT OUTER JOIN  followers ON followers.id = videos.follower_id
LEFT OUTER JOIN  leaders ON leaders.id = videos.leader_id
LEFT OUTER JOIN  songs ON songs.id = videos.song_id;
