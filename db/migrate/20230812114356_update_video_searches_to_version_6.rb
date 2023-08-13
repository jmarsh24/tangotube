# frozen_string_literal: true

class UpdateVideoSearchesToVersion6 < ActiveRecord::Migration[7.0]
  def change
    ActiveRecord::Base.connection.execute("SET statement_timeout TO 0")
    update_view :video_searches, version: 6, revert_to_version: 5, materialized: true
    add_index :video_searches, :video_description_vector, using: :gin
    ActiveRecord::Base.connection.execute("SET statement_timeout TO 60000")
  end
end
