class UpdateVideoSearchesToVersion7 < ActiveRecord::Migration[7.0]
  def change
    ActiveRecord::Base.connection.execute("SET statement_timeout TO 0")
    update_view :video_searches, version: 7, revert_to_version: 6, materialized: true
    ActiveRecord::Base.connection.execute("SET statement_timeout TO 60000")
  end
end
