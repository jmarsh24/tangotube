WITH likes_count AS (
  SELECT
    likeable_id AS video_id,
    SUM(EXP(-0.0000000001 * EXTRACT(EPOCH FROM NOW() - likes.created_at))) AS decayed_likes
  FROM likes
  WHERE likeable_type = 'Video'
  GROUP BY likeable_id
),
watches_count AS (
  SELECT
    video_id,
    SUM(EXP(-0.000000001 * EXTRACT(EPOCH FROM NOW() - watches.created_at))) AS decayed_watches
  FROM watches
  GROUP BY video_id
),
max_values AS (
  SELECT
    GREATEST(MAX(lc.decayed_likes), 1) AS max_likes,
    GREATEST(MAX(wc.decayed_watches), 1) AS max_watches
  FROM
    likes_count lc
    CROSS JOIN watches_count wc
),
videos_with_score AS (
  SELECT
    videos.id AS video_id,
    (EXTRACT(EPOCH FROM videos.upload_date) - (SELECT MIN(EXTRACT(EPOCH FROM upload_date)) FROM videos)) / ((SELECT MAX(EXTRACT(EPOCH FROM upload_date)) FROM videos) - (SELECT MIN(EXTRACT(EPOCH FROM upload_date)) FROM videos)) AS normalized_upload_time,
    COALESCE(lc.decayed_likes / mv.max_likes, 0) AS decayed_normalized_likes,
    COALESCE(wc.decayed_watches / mv.max_watches, 0) AS decayed_normalized_watches,
    CASE
      WHEN EXISTS (SELECT 1 FROM dancer_videos WHERE dancer_videos.video_id = videos.id) THEN 0.1
      ELSE 0
    END AS dancer_score_adjustment
  FROM
    videos
    LEFT JOIN likes_count lc ON videos.id = lc.video_id
    LEFT JOIN watches_count wc ON videos.id = wc.video_id
    CROSS JOIN max_values mv
)
SELECT
  video_id,
  (0.1 * normalized_upload_time + 0.3 * decayed_normalized_likes + 0.2 * decayed_normalized_watches + 0.3 * RANDOM() + dancer_score_adjustment) AS score_1,
  (0.1 * normalized_upload_time + 0.3 * decayed_normalized_likes + 0.2 * decayed_normalized_watches + 0.3 * RANDOM() + dancer_score_adjustment) AS score_2,
  (0.1 * normalized_upload_time + 0.3 * decayed_normalized_likes + 0.2 * decayed_normalized_watches + 0.3 * RANDOM() + dancer_score_adjustment) AS score_3,
  (0.1 * normalized_upload_time + 0.3 * decayed_normalized_likes + 0.2 * decayed_normalized_watches + 0.3 * RANDOM() + dancer_score_adjustment) AS score_4,
  (0.1 * normalized_upload_time + 0.3 * decayed_normalized_likes + 0.2 * decayed_normalized_watches + 0.3 * RANDOM() + dancer_score_adjustment) AS score_5
FROM videos_with_score
