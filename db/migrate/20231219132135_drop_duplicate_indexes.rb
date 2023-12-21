# frozen_string_literal: true

class DropDuplicateIndexes < ActiveRecord::Migration[7.1]
  def change
    remove_index :couple_videos, column: :video_id

    remove_index :couples, column: :dancer_id

    remove_index :dancer_videos, column: :dancer_id

    remove_index :features, column: :user_id

    remove_index :friendly_id_slugs, column: [:slug, :sluggable_type]

    remove_index :good_jobs, column: :active_job_id

    remove_index :likes, column: :user_id

    remove_index :performance_videos, column: :performance_id
  end
end
