# frozen_string_literal: true

module Import
  module Youtube
    class ScrapedData
      include StoreModel::Model

      attribute :song, SongMetadata.to_type
      attribute :recommended_video_ids, :array_of_strings, default: -> { [] }
    end
  end
end
