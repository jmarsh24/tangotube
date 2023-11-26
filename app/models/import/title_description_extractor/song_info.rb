# frozen_string_literal: true

module Import
  module TitleDescriptionExtractor
    class SongInfo
      include StoreModel::Model

      attribute :title
      attribute :artist_names, :array_of_strings
    end
  end
end
