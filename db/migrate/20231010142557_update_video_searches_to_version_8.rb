# frozen_string_literal: true

class UpdateVideoSearchesToVersion8 < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    ActiveRecord::Base.transaction do
      update_view :video_scores, version: 8, revert_to_version: 7, materialized: true
    end

    add_index :video_searches, :search_text, using: :gin, opclass: :gin_trgm_ops, algorithm: :concurrently
  end
end
