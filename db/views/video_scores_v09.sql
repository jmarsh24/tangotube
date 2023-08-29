WITH combined_counts AS (
    SELECT
        v.id AS video_id,
        COALESCE(COUNT(DISTINCT likes.likeable_id), 0) AS total_likes,
        COALESCE(COUNT(DISTINCT watches.user_id), 0) AS total_watches,
        COALESCE(COUNT(DISTINCT features.featureable_id), 0) AS total_features,
        CASE
            WHEN EXISTS (SELECT 1 FROM dancer_videos dv WHERE dv.video_id = v.id) THEN 0.1
            ELSE 0
        END AS dancer_score_adjustment
    FROM
        videos v
        LEFT JOIN likes 
            ON v.id = likes.likeable_id 
            AND likes.likeable_type = 'Video' 
            AND likes.created_at > NOW() - INTERVAL '6 days'
        LEFT JOIN watches 
            ON v.id = watches.video_id 
            AND watches.created_at > NOW() - INTERVAL '6 days'
        LEFT JOIN features 
            ON v.id = features.featureable_id 
            AND features.featureable_type = 'Video'
    GROUP BY v.id
),
upload_date_range AS (
    SELECT
        MIN(EXTRACT(EPOCH FROM upload_date)) AS min_upload_epoch,
        MAX(EXTRACT(EPOCH FROM upload_date)) AS max_upload_epoch
    FROM videos
),
norm_counts AS (
    SELECT video_id, 
           CAST(total_likes AS FLOAT) / NULLIF(MAX(total_likes) OVER (), 0) AS normalized_likes,
           CAST(total_watches AS FLOAT) / NULLIF(MAX(total_watches) OVER (), 0) AS normalized_watches,
           CAST(total_features AS FLOAT) / NULLIF(MAX(total_features) OVER (), 0) AS normalized_features,
           dancer_score_adjustment,
           total_likes,
           total_watches,
           total_features
    FROM combined_counts
)

SELECT
    cc.video_id,
    v.title AS video_title,

    -- Recent Uploads
    (0.5 * (EXTRACT(EPOCH FROM v.upload_date) - udr.min_upload_epoch) / (udr.max_upload_epoch - udr.min_upload_epoch)
    + 0.2 * cc.normalized_likes
    + 0.15 * cc.normalized_watches
    + 0.05 * cc.normalized_features
    + 0.05 * RANDOM()
    + cc.dancer_score_adjustment) AS score_1,

    -- Popular Videos
    (0.15 * (EXTRACT(EPOCH FROM v.upload_date) - udr.min_upload_epoch) / (udr.max_upload_epoch - udr.min_upload_epoch)
    + 0.35 * cc.normalized_likes
    + 0.35 * cc.normalized_watches
    + 0.1 * cc.normalized_features
    + 0.025 * RANDOM()
    + cc.dancer_score_adjustment) AS score_2,

    -- Randomized Preference
    (0.1 * (EXTRACT(EPOCH FROM v.upload_date) - udr.min_upload_epoch) / (udr.max_upload_epoch - udr.min_upload_epoch)
    + 0.25 * cc.normalized_likes
    + 0.25 * cc.normalized_watches
    + 0.15 * cc.normalized_features
    + 0.2 * RANDOM()
    + cc.dancer_score_adjustment) AS score_3,

    -- Dancer Spotlight
    (0.1 * (EXTRACT(EPOCH FROM v.upload_date) - udr.min_upload_epoch) / (udr.max_upload_epoch - udr.min_upload_epoch)
    + 0.2 * cc.normalized_likes
    + 0.2 * cc.normalized_watches
    + 0.1 * cc.normalized_features
    + 0.1 * RANDOM()
    + 0.3 * cc.dancer_score_adjustment) AS score_4,

    -- Balanced Approach
    (0.2 * (EXTRACT(EPOCH FROM v.upload_date) - udr.min_upload_epoch) / (udr.max_upload_epoch - udr.min_upload_epoch)
    + 0.3 * cc.normalized_likes
    + 0.3 * cc.normalized_watches
    + 0.1 * cc.normalized_features
    + 0.05 * RANDOM()
    + 0.05 * cc.dancer_score_adjustment) AS score_5,

    -- Older but Popular Score
    (0.5 * (1 - (EXTRACT(EPOCH FROM v.upload_date) - udr.min_upload_epoch) / (udr.max_upload_epoch - udr.min_upload_epoch)) 
    + 0.3 * cc.normalized_likes
    + 0.15 * cc.normalized_watches
    + 0.05 * cc.normalized_features) AS score_6

FROM norm_counts cc
JOIN videos v ON cc.video_id = v.id
CROSS JOIN upload_date_range udr;
