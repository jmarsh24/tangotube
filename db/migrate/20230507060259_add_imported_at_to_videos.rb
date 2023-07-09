# frozen_string_literal: true

class AddImportedAtToVideos < ActiveRecord::Migration[7.0]
  def change
    add_column :videos, :imported_at, :datetime
  end
end
