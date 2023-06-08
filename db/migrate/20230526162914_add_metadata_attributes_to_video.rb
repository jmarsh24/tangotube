class AddMetadataAttributesToVideo < ActiveRecord::Migration[7.1]
  def change
    add_column :videos, :upload_date_year, :integer
    add_column :videos, :title, :text
    add_column :videos, :description, :text
    add_column :videos, :hd, :boolean
    add_column :videos, :youtube_view_count, :integer
    add_column :videos, :youtube_like_count, :integer
    add_column :videos, :youtube_tags, :text, array: true, default: []
    add_column :videos, :duration, :integer
  end
end
