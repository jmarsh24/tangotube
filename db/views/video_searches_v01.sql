SELECT
    videos.id AS video_id,
    videos.youtube_id AS youtube_id,
    videos.click_count AS click_count,
    videos.upload_date AS upload_date,
    LOWER(CONCAT_WS(' ', STRING_AGG(DISTINCT normalize(dancers.name), ' '))) AS dancers_names,
    LOWER(CONCAT_WS(' ', STRING_AGG(DISTINCT normalize(channels.title), ' '))) AS channels_title,
    LOWER(CONCAT_WS(' ', STRING_AGG(DISTINCT normalize(songs.title), ' '))) AS songs_title,
    LOWER(CONCAT_WS(' ', STRING_AGG(DISTINCT normalize(songs.artist), ' '))) AS songs_artist,
    LOWER(CONCAT_WS(' ', STRING_AGG(DISTINCT normalize(orchestras.name), ' '))) AS orchestras_name,
    LOWER(CONCAT_WS(' ', STRING_AGG(DISTINCT normalize(events.city), ' '))) AS events_city,
    LOWER(CONCAT_WS(' ', STRING_AGG(DISTINCT normalize(events.title), ' '))) AS events_title,
    LOWER(CONCAT_WS(' ', STRING_AGG(DISTINCT normalize(events.country), ' '))) AS events_country,
    normalize(videos.title) AS videos_title,
    normalize(videos.description) AS videos_description
  FROM videos
  LEFT JOIN channels ON channels.id = videos.channel_id
  LEFT JOIN songs ON songs.id = videos.song_id
  LEFT JOIN events ON events.id = videos.event_id
  LEFT JOIN dancer_videos ON dancer_videos.video_id = videos.id
  LEFT JOIN dancers ON dancers.id = dancer_videos.dancer_id
  LEFT JOIN orchestras ON orchestras.id = songs.orchestra_id
  GROUP BY videos.id, videos.youtube_id
