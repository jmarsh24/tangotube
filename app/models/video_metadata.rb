# frozen_string_literal: true

VideoMetadata =
  Struct.new(
    :slug,
    :youtube,
    :acr_cloud,
    keyword_init: true
  )
