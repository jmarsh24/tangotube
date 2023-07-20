SELECT
    videos.id AS video_id,
    videos.youtube_id AS youtube_id,
    videos.upload_date AS upload_date,
    LOWER(CONCAT_WS(' ', STRING_AGG(DISTINCT dancers.name, ' '))) AS dancer_names,
    LOWER(CONCAT_WS(' ', STRING_AGG(DISTINCT channels.title, ' '))) AS channel_title,
    LOWER(CONCAT_WS(' ', STRING_AGG(DISTINCT songs.title, ' '))) AS song_title,
    LOWER(CONCAT_WS(' ', STRING_AGG(DISTINCT songs.artist, ' '))) AS song_artist,
    LOWER(CONCAT_WS(' ', STRING_AGG(DISTINCT orchestras.name, ' '))) AS orchestra_name,
    LOWER(CONCAT_WS(' ', STRING_AGG(DISTINCT events.city, ' '))) AS event_city,
    LOWER(CONCAT_WS(' ', STRING_AGG(DISTINCT events.title, ' '))) AS event_title,
    LOWER(CONCAT_WS(' ', STRING_AGG(DISTINCT events.country, ' '))) AS event_country,
    LOWER(normalize(videos.title)) AS video_title,
    video_scores.score_1 AS score_1
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
ORDER BY score_1 DESC
