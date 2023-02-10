# frozen_string_literal: true

class AddTrigramIndexToVideosText < ActiveRecord::Migration[7.0]
  def change
    add_index :videos, :index, opclass: {index: :gin_trgm_ops}, using: :gin
  end
end
