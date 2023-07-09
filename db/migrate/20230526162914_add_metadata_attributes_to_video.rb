# frozen_string_literal: true

class AddMetadataAttributesToVideo < ActiveRecord::Migration[7.0]
  def change
    add_column :videos, :upload_date_year, :integer
    add_column :videos, :youtube_view_count, :integer
    add_column :videos, :youtube_like_count, :integer
    add_column :videos, :youtube_tags, :text, array: true, default: []
  end
end
