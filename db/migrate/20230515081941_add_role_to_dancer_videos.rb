# frozen_string_literal: true

class AddRoleToDancerVideos < ActiveRecord::Migration[7.1]
  def up
    create_enum "role_new", ["neither", "leader", "follower", "both"]
    add_column :dancer_videos, :role_new, :role_new

    execute <<-SQL
      UPDATE dancer_videos SET role_new = CASE role
        WHEN '0' THEN 'neither'::role_new
        WHEN '1' THEN 'leader'::role_new
        WHEN '2' THEN 'follower'::role_new
        WHEN '3' THEN 'both'::role_new
      END
    SQL

    remove_column :dancer_videos, :role
    rename_column :dancer_videos, :role_new, :role
  end

  def down
    add_column :dancer_videos, :role_new, :text

    execute <<-SQL
      UPDATE dancer_videos SET role_new = CASE role
        WHEN 'neither' THEN '0'
        WHEN 'leader' THEN '1'
        WHEN 'follower' THEN '2'
        WHEN 'both' THEN '3'
      END
    SQL

    remove_column :dancer_videos, :role
    rename_column :dancer_videos, :role_new, :role
    drop_enum "role_new"
  end
end
