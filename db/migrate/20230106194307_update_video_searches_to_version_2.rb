# frozen_string_literal: true

class UpdateVideoSearchesToVersion2 < ActiveRecord::Migration[7.0]
  def change
    ActiveRecord::Base.connection.execute("SET statement_timeout = '10000s'")
    update_view(:video_searches,
      version: 2,
      revert_to_version: 1,
      materialized: true)
  ensure
    ActiveRecord::Base.connection.execute("SET statement_timeout = #{ENV.fetch("DB_SESSION_TIMEOUT", 3000)}")
  end
end
