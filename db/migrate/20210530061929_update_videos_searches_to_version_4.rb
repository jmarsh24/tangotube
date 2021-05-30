class UpdateVideosSearchesToVersion4 < ActiveRecord::Migration[6.1]
  def change
    update_view :videos_searches, version: 4, revert_to_version: 3, materialized: true
  end
end
