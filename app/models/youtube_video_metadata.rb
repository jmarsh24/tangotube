# frozen_string_literal: true

YoutubeVideoMetadata =
  Struct.new(:slug,
    :title,
    :description,
    :upload_date,
    :duration,
    :tags,
    :hd,
    :view_count,
    :favorite_count,
    :comment_count,
    :like_count,
    :song,
    :thumbnail_urls,
    keyword_init: true)
