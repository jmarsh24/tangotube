# frozen_string_literal: true

module ExternalVideoImport
  module VideoCrawl
    module Youtube
      VideoThumbnailUrl =
        Struct.new(
          :default,
          :medium,
          :high,
          :standard,
          :maxres,
          keyword_init: true
        )
    end
  end
end
