# frozen_string_literal: true

module ExternalVideoImport
  module Youtube
    VideoMetadata = Struct.new(
      :slug,
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
      :thumbnail_url,
      :recommended_video_ids,
      :channel,
      keyword_init: true
    )
  end
end
