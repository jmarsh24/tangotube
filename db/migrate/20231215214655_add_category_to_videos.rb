# frozen_string_literal: true

class AddCategoryToVideos < ActiveRecord::Migration[7.1]
  def up
    # Create a new enum type
    create_enum :video_category, ["performance", "workshop", "class", "demo", "interview", "podcast", "competition"]

    # Add a new column with the enum type to the videos table
    # Ensure to specify the table name and set default value as null or as appropriate
    add_column :videos, :category, :video_category, null: true
  end

  def down
    # Remove the column first in the rollback
    remove_column :videos, :category

    # Then drop the enum type
    drop_enum :video_category
  end
end
