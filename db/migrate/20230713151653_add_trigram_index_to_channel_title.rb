# frozen_string_literal: true

class AddTrigramIndexToChannelTitle < ActiveRecord::Migration[7.0]
  def change
    remove_index :channels, :title
    add_index :channels, :title, using: :gin, opclass: :gin_trgm_ops, name: "index_channels_on_title_trigram"
  end
end
