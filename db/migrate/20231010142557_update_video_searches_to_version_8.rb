# frozen_string_literal: true

class UpdateVideoSearchesToVersion8 < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    add_index :video_searches, :search_text, using: :gin, opclass: :gin_trgm_ops, algorithm: :concurrently
  end
end
