# frozen_string_literal: true

ThumbnailUrl =
  Struct.new(
    :default,
    :medium,
    :high,
    :standard,
    :maxres,
    keyword_init: true
  )
