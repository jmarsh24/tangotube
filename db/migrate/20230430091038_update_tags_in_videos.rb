# frozen_string_literal: true

class UpdateTagsInVideos < ActiveRecord::Migration[6.1]
  def up
    # Add a temporary column to store the new tags data
    add_column :videos, :temp_tags, :text, array: true, default: []

    # Convert the existing tags data to an array format and store it in the temporary column
    Video.find_each do |video|
      if video.tags.present?
        tags_array = video.tags[1..-2].split(",").map(&:strip)
        video.update_column(:temp_tags, tags_array)
      else
        video.update_column(:temp_tags, [])
      end
    end

    # Update the schema to store tags as an array
    remove_column :videos, :tags
    rename_column :videos, :temp_tags, :tags
  end

  def down
    # Add a temporary column to store the old tags data
    add_column :videos, :temp_tags, :string

    # Convert the tags array back to a single string for each video and store it in the temporary column
    Video.find_each do |video|
      tags_string = video.tags.inspect
      video.update_column(:temp_tags, tags_string)
    end

    # Revert the schema change
    remove_column :videos, :tags
    rename_column :videos, :temp_tags, :tags
  end
end
