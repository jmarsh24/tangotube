# frozen_string_literal: true

class AddIndexToVideos < ActiveRecord::Migration[7.0]
  def change
    add_index :videos, :index, using: :gist, opclass: :gist_trgm_ops
  end
end
