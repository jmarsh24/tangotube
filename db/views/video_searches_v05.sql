SELECT
    videos.id AS video_id,
    videos.youtube_id AS youtube_id,
    videos.upload_date AS upload_date,
    TRIM(LOWER(unaccent(REGEXP_REPLACE(CONCAT_WS(' ', STRING_AGG(DISTINCT dancers.name, ' ')), '[^\w\s]', ' ', 'g')))) AS dancer_names,
    TRIM(LOWER(unaccent(REGEXP_REPLACE(CONCAT_WS(' ', STRING_AGG(DISTINCT channels.title, ' ')), '[^\w\s]', ' ', 'g')))) AS channel_title,
    TRIM(LOWER(unaccent(REGEXP_REPLACE(CONCAT_WS(' ', STRING_AGG(DISTINCT songs.title, ' ')), '[^\w\s]', ' ', 'g')))) AS song_title,
    TRIM(LOWER(unaccent(REGEXP_REPLACE(CONCAT_WS(' ', STRING_AGG(DISTINCT songs.artist, ' ')), '[^\w\s]', ' ', 'g')))) AS song_artist,
    TRIM(LOWER(unaccent(REGEXP_REPLACE(CONCAT_WS(' ', STRING_AGG(DISTINCT orchestras.name, ' ')), '[^\w\s]', ' ', 'g')))) AS orchestra_name,
    TRIM(LOWER(unaccent(REGEXP_REPLACE(CONCAT_WS(' ', STRING_AGG(DISTINCT events.city, ' ')), '[^\w\s]', ' ', 'g')))) AS event_city,
    TRIM(LOWER(unaccent(REGEXP_REPLACE(CONCAT_WS(' ', STRING_AGG(DISTINCT events.title, ' ')), '[^\w\s]', ' ', 'g')))) AS event_title,
    TRIM(LOWER(unaccent(REGEXP_REPLACE(CONCAT_WS(' ', STRING_AGG(DISTINCT events.country, ' ')), '[^\w\s]', ' ', 'g')))) AS event_country,
    TRIM(LOWER(unaccent(REGEXP_REPLACE(normalize(videos.title), '[^\w\s]', ' ', 'g')))) AS video_title,
    video_scores.score_1 AS score
FROM videos
LEFT JOIN watches ON videos.id = watches.video_id
LEFT JOIN likes ON videos.id = likes.likeable_id AND likes.likeable_type = 'Video'
LEFT JOIN channels ON channels.id = videos.channel_id
LEFT JOIN songs ON songs.id = videos.song_id
LEFT JOIN events ON events.id = videos.event_id
LEFT JOIN dancer_videos ON dancer_videos.video_id = videos.id
LEFT JOIN dancers ON dancers.id = dancer_videos.dancer_id
LEFT JOIN orchestras ON orchestras.id = songs.orchestra_id
LEFT JOIN video_scores ON video_scores.video_id = videos.id
GROUP BY videos.id, videos.youtube_id, video_scores.score_1
ORDER BY score DESC;
