# frozen_string_literal: true

module ExternalVideoImport
  module VideoCrawl
    module Youtube
      ThumbnailUrl =
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
