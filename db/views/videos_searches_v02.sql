SELECT
  videos.id AS video_id,
  (    to_tsvector('unaccentdict', coalesce(channels.title,''))
    || to_tsvector('unaccentdict', coalesce(followers.name,''))
    || to_tsvector('unaccentdict', coalesce(followers.nickname,''))
    || to_tsvector('unaccentdict', coalesce(leaders.name,''))
    || to_tsvector('unaccentdict', coalesce(leaders.nickname,''))
    || to_tsvector('unaccentdict', coalesce(songs.genre,''))
    || to_tsvector('unaccentdict', coalesce(songs.title,''))
    || to_tsvector('unaccentdict', coalesce(songs.artist,''))
    || to_tsvector('unaccentdict', coalesce(videos.acr_cloud_track_name,''))
    || to_tsvector('unaccentdict', coalesce(videos.acr_cloud_artist_name,''))
    || to_tsvector('unaccentdict', coalesce(videos.description,''))
    || to_tsvector('unaccentdict', coalesce(videos.title,''))
    || to_tsvector('unaccentdict', coalesce(videos.youtube_artist,''))
    || to_tsvector('unaccentdict', coalesce(videos.youtube_id,''))
    || to_tsvector('unaccentdict', coalesce(videos.youtube_song,''))
    || to_tsvector('unaccentdict', coalesce(videos.spotify_artist_name,''))
    || to_tsvector('unaccentdict', coalesce(videos.spotify_track_name,''))
    || to_tsvector('unaccentdict', coalesce(videos.tags,''))
  ) AS tsv_document
FROM videos
LEFT OUTER JOIN  channels ON channels.id = videos.channel_id
LEFT OUTER JOIN  followers ON followers.id = videos.follower_id
LEFT OUTER JOIN  leaders ON leaders.id = videos.leader_id
LEFT OUTER JOIN  songs ON songs.id = videos.song_id;
