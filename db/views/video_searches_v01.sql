SELECT
    videos.id AS video_id,
    videos.youtube_id AS youtube_id,
    videos.click_count AS click_count,
    videos.upload_date AS upload_date,
    LOWER(CONCAT_WS(' ', STRING_AGG(dancers.name, ' '))) AS dancer_names,
    LOWER(CONCAT_WS(' ', STRING_AGG(channels.title, ' '))) AS channel_title,
    LOWER(CONCAT_WS(' ', STRING_AGG(songs.title, ' '))) AS song_title,
    LOWER(CONCAT_WS(' ', STRING_AGG(songs.artist, ' '))) AS song_artist,
    LOWER(CONCAT_WS(' ', STRING_AGG(orchestras.name, ' '))) AS orchestra_name,
    LOWER(CONCAT_WS(' ', STRING_AGG(events.city, ' '))) AS event_city,
    LOWER(CONCAT_WS(' ', STRING_AGG(events.title, ' '))) AS event_title,
    LOWER(CONCAT_WS(' ', STRING_AGG(events.country, ' '))) AS event_country,
    LOWER(normalize(videos.title)) AS video_title
  FROM videos
  LEFT JOIN channels ON channels.id = videos.channel_id
  LEFT JOIN songs ON songs.id = videos.song_id
  LEFT JOIN events ON events.id = videos.event_id
  LEFT JOIN dancer_videos ON dancer_videos.video_id = videos.id
  LEFT JOIN dancers ON dancers.id = dancer_videos.dancer_id
  LEFT JOIN orchestras ON orchestras.id = songs.orchestra_id
  GROUP BY videos.id, videos.youtube_id
