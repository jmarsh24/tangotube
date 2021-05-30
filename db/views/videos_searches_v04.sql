SELECT
  videos.id AS video_id,
  (    to_tsvector('unaccentdict', coalesce(REPLACE(channels.title,'''',''),''))
    || to_tsvector('unaccentdict', coalesce(REPLACE(channels.channel_id,'''',''),''))
    || to_tsvector('unaccentdict', coalesce(REPLACE(followers.name,'''',''),''))
    || to_tsvector('unaccentdict', coalesce(REPLACE(followers.nickname,'''',''),''))
    || to_tsvector('unaccentdict', coalesce(REPLACE(leaders.name,'''',''),''))
    || to_tsvector('unaccentdict', coalesce(REPLACE(leaders.nickname,'''',''),''))
    || to_tsvector('unaccentdict', coalesce(REPLACE(songs.genre,'''',''),''))
    || to_tsvector('unaccentdict', coalesce(REPLACE(songs.title,'''',''),''))
    || to_tsvector('unaccentdict', coalesce(REPLACE(songs.artist,'''',''),''))
    || to_tsvector('unaccentdict', coalesce(REPLACE(videos.acr_cloud_artist_name,'''',''),''))
    || to_tsvector('unaccentdict', coalesce(REPLACE(videos.description,'''',''),''))
    || to_tsvector('unaccentdict', coalesce(REPLACE(videos.title,'''',''),''))
    || to_tsvector('unaccentdict', coalesce(REPLACE(videos.youtube_artist,'''',''),''))
    || to_tsvector('unaccentdict', coalesce(REPLACE(videos.youtube_id,'''',''),''))
    || to_tsvector('unaccentdict', coalesce(REPLACE(videos.youtube_song,'''',''),''))
    || to_tsvector('unaccentdict', coalesce(REPLACE(videos.spotify_artist_name,'''',''),''))
    || to_tsvector('unaccentdict', coalesce(REPLACE(videos.spotify_track_name,'''',''),''))
    || to_tsvector('unaccentdict', coalesce(REPLACE(videos.tags,'''',''),''))
  ) AS tsv_document
FROM videos
LEFT OUTER JOIN  channels ON channels.id = videos.channel_id
LEFT OUTER JOIN  followers ON followers.id = videos.follower_id
LEFT OUTER JOIN  leaders ON leaders.id = videos.leader_id
LEFT OUTER JOIN  songs ON songs.id = videos.song_id;
