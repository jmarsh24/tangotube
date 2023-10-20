SELECT
    videos.id AS video_id,
    videos.youtube_id AS youtube_id,
    videos.upload_date AS upload_date,
    videos.description AS video_description,
    to_tsvector ('english', videos.description) AS video_description_vector,
    TRIM(
        LOWER(
            unaccent (
                REGEXP_REPLACE (
                    CONCAT_WS (' ', STRING_AGG (DISTINCT dancers.name, ' ')),
                    '[^\w\s]',
                    ' ',
                    'g'
                )
            )
        )
    ) AS dancer_names,
    TRIM(
        LOWER(
            unaccent (
                REGEXP_REPLACE (
                    CONCAT_WS (' ', STRING_AGG (DISTINCT channels.title, ' ')),
                    '[^\w\s]',
                    ' ',
                    'g'
                )
            )
        )
    ) AS channel_title,
    TRIM(
        LOWER(
            unaccent (
                REGEXP_REPLACE (
                    CONCAT_WS (' ', STRING_AGG (DISTINCT songs.title, ' ')),
                    '[^\w\s]',
                    ' ',
                    'g'
                )
            )
        )
    ) AS song_title,
    TRIM(
        LOWER(
            unaccent (
                REGEXP_REPLACE (
                    CONCAT_WS (' ', STRING_AGG (DISTINCT songs.artist, ' ')),
                    '[^\w\s]',
                    ' ',
                    'g'
                )
            )
        )
    ) AS song_artist,
    TRIM(
        LOWER(
            unaccent (
                REGEXP_REPLACE (
                    CONCAT_WS (' ', STRING_AGG (DISTINCT orchestras.name, ' ')),
                    '[^\w\s]',
                    ' ',
                    'g'
                )
            )
        )
    ) AS orchestra_name,
    TRIM(
        LOWER(
            unaccent (
                REGEXP_REPLACE (
                    CONCAT_WS (' ', STRING_AGG (DISTINCT events.city, ' ')),
                    '[^\w\s]',
                    ' ',
                    'g'
                )
            )
        )
    ) AS event_city,
    TRIM(
        LOWER(
            unaccent (
                REGEXP_REPLACE (
                    CONCAT_WS (' ', STRING_AGG (DISTINCT events.title, ' ')),
                    '[^\w\s]',
                    ' ',
                    'g'
                )
            )
        )
    ) AS event_title,
    TRIM(
        LOWER(
            unaccent (
                REGEXP_REPLACE (
                    CONCAT_WS (' ', STRING_AGG (DISTINCT events.country, ' ')),
                    '[^\w\s]',
                    ' ',
                    'g'
                )
            )
        )
    ) AS event_country,
    TRIM(
        LOWER(
            unaccent (
                REGEXP_REPLACE (normalize(videos.title), '[^\w\s]', ' ', 'g')
            )
        )
    ) AS video_title,
    TRIM(
        LOWER(
            unaccent (
                REGEXP_REPLACE (
                    CONCAT_WS (
                        ' ',
                        STRING_AGG (DISTINCT dancers.name, ' '),
                        STRING_AGG (DISTINCT channels.title, ' '),
                        STRING_AGG (DISTINCT songs.title, ' '),
                        STRING_AGG (DISTINCT songs.artist, ' '),
                        STRING_AGG (DISTINCT orchestras.name, ' '),
                        STRING_AGG (DISTINCT events.city, ' '),
                        STRING_AGG (DISTINCT events.title, ' '),
                        STRING_AGG (DISTINCT events.country, ' '),
                        normalize(videos.title)
                    ),
                    '[^\w\s]',
                    ' ',
                    'g'
                )
            )
        )
    ) AS search_text
FROM
    videos
    LEFT JOIN channels ON channels.id = videos.channel_id
    LEFT JOIN songs ON songs.id = videos.song_id
    LEFT JOIN events ON events.id = videos.event_id
    LEFT JOIN dancer_videos ON dancer_videos.video_id = videos.id
    LEFT JOIN dancers ON dancers.id = dancer_videos.dancer_id
    LEFT JOIN orchestras ON orchestras.id = songs.orchestra_id
GROUP BY
    videos.id,
    videos.youtube_id,
    videos.upload_date,
    videos.description,
    videos.title
ORDER BY
    video_id DESC;