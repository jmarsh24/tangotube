SELECT
  videos.id AS video_id,
  (    setweight(to_tsvector('pg_catalog.english', coalesce(channels.title,'')), 'C')
    || setweight(to_tsvector('pg_catalog.english', coalesce(channels.channel_id,'')), 'C')
    || setweight(to_tsvector('pg_catalog.english', coalesce(string_agg(dancers.name, ' ; '),'')), 'C')
    || setweight(to_tsvector('pg_catalog.english', coalesce(string_agg(dancers.nick_name, ' ; '),'')), 'C')
    || setweight(to_tsvector('pg_catalog.english', coalesce(leaders.name,'')), 'C')
    || setweight(to_tsvector('pg_catalog.english', coalesce(leaders.nickname,'')), 'C')
    || setweight(to_tsvector('pg_catalog.english', coalesce(followers.name,'')), 'C')
    || setweight(to_tsvector('pg_catalog.english', coalesce(followers.nickname,'')), 'C')
    || setweight(to_tsvector('pg_catalog.english', coalesce(events.city,'')), 'C')
    || setweight(to_tsvector('pg_catalog.english', coalesce(events.title,'')), 'C')
    || setweight(to_tsvector('pg_catalog.english', coalesce(events.country,'')), 'C')
    || setweight(to_tsvector('pg_catalog.english', coalesce(songs.genre,'')), 'C')
    || setweight(to_tsvector('pg_catalog.english', coalesce(songs.title,'')), 'C')
    || setweight(to_tsvector('pg_catalog.english', coalesce(songs.artist,'')), 'C')
    || setweight(to_tsvector('pg_catalog.english', coalesce(videos.acr_cloud_track_name,'')), 'C')
    || setweight(to_tsvector('pg_catalog.english', coalesce(videos.acr_cloud_artist_name,'')), 'C')
    || setweight(to_tsvector('pg_catalog.english', coalesce(videos.description,'')), 'C')
    || setweight(to_tsvector('pg_catalog.english', coalesce(videos.title,'')), 'A')
    || setweight(to_tsvector('pg_catalog.english', coalesce(videos.youtube_artist,'')), 'B')
    || setweight(to_tsvector('pg_catalog.english', coalesce(videos.youtube_id,'')), 'B')
    || setweight(to_tsvector('pg_catalog.english', coalesce(videos.youtube_song,'')), 'B')
    || setweight(to_tsvector('pg_catalog.english', coalesce(videos.spotify_artist_name,'')), 'B')
    || setweight(to_tsvector('pg_catalog.english', coalesce(videos.spotify_track_name,'')), 'B')
    || setweight(to_tsvector('pg_catalog.english', coalesce(videos.tags,'')), 'B')
  ) AS tsv_content_tsearch
FROM videos
LEFT OUTER JOIN channels ON channels.id = videos.channel_id
LEFT OUTER JOIN leaders ON leaders.id = videos.leader_id
LEFT OUTER JOIN followers ON followers.id = videos.follower_id
LEFT OUTER JOIN songs ON songs.id = videos.song_id
LEFT OUTER JOIN events ON events.id = videos.event_id
JOIN dancer_videos ON dancer_videos.video_id = videos.id
JOIN dancers ON dancers.id = dancer_videos.dancer_id
GROUP BY videos.id, channels.id, songs.id, events.id, leaders.id, followers.id;
