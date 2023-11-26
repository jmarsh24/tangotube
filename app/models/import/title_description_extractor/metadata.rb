# frozen_string_literal: true

require "store_model"

module Import
  module TitleDescriptionExtractor
    class Metadata
      include StoreModel::Model

      attribute :event_title, :string
      attribute :dancer_names, :array_of_strings
      attribute :song_info, SongInfo.to_type
    end
  end
end
