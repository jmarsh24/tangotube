class UpdateVideoSearchesToVersion8 < ActiveRecord::Migration[7.1]
  def change
    ActiveRecord::Base.connection.execute("SET statement_timeout TO 0")
    update_view :video_searches, version: 8, revert_to_version: 7, materialized: true
    add_index :video_searches, :search_text, using: :gin, opclass: :gin_trgm_ops
    ActiveRecord::Base.connection.execute("SET statement_timeout TO 60000")
  end
end
