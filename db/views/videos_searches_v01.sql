SELECT
  videos.id AS video_id,
  (    to_tsvector('english', coalesce(unaccent(videos.title), ''))
    || to_tsvector('english', coalesce(unaccent(videos.description), ''))
    || to_tsvector('english', coalesce(unaccent(videos.youtube_id), ''))
    || to_tsvector('english', coalesce(unaccent(videos.youtube_artist), ''))
    || to_tsvector('english', coalesce(unaccent(videos.youtube_song), ''))
    || to_tsvector('english', coalesce(unaccent(videos.spotify_track_name), ''))
    || to_tsvector('english', coalesce(unaccent(videos.spotify_artist_name), ''))
    || to_tsvector('english', coalesce(unaccent(channels.title), ''))
    || to_tsvector('english', coalesce(unaccent(channels.channel_id), ''))
    || to_tsvector('english', coalesce(unaccent(leaders.name), ''))
    || to_tsvector('english', coalesce(unaccent(leaders.nickname), ''))
    || to_tsvector('english', coalesce(unaccent(followers.name), ''))
    || to_tsvector('english', coalesce(unaccent(followers.nickname), ''))
    || to_tsvector('english', coalesce(unaccent(songs.genre), ''))
    || to_tsvector('english', coalesce(unaccent(songs.title), ''))
    || to_tsvector('english', coalesce(unaccent(songs.artist), ''))
  ) AS tsv_document
FROM videos
LEFT OUTER JOIN  channels ON channels.id = videos.channel_id
LEFT OUTER JOIN  followers ON followers.id = videos.follower_id
LEFT OUTER JOIN  leaders ON leaders.id = videos.leader_id
LEFT OUTER JOIN  songs ON songs.id = videos.song_id;
