# frozen_string_literal: true

module ExternalVideoImport
  module VideoCrawl
    VideoMetadata =
      Struct.new(
        :youtube,
        :acr_cloud,
        keyword_init: true
      )
  end
end
