class DropVideosSearches < ActiveRecord::Migration[7.0]
  def change
    execute <<-SQL
      DROP MATERIALIZED VIEW if exists videos_searches
    SQL
  end
end
