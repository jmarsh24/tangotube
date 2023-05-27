class MoveMetadataAttributesToVideo < ActiveRecord::Migration[7.1]
  def up
    add_column :videos, :upload_date_year, :integer, default: 0
    add_column :videos, :title, :string
    add_column :videos, :description, :text
    add_column :videos, :hd, :boolean, default: false
    add_column :videos, :youtube_view_count, :integer, default: 0
    add_column :videos, :youtube_like_count, :integer, default: 0
    add_column :videos, :youtube_tags, :string, array: true, default: []
    add_column :videos, :duration, :integer, default: 0

    Video.reset_column_information

    Video.find_each do |video|
      metadata = video.metadata.youtube
      next if metadata.nil?

      video.update!(
        upload_date_year: metadata.upload_date.year,
        title: metadata.title,
        description: metadata.description,
        hd: metadata.hd || false,
        youtube_view_count: metadata.view_count || 0,
        youtube_like_count: metadata.like_count || 0,
        youtube_tags: metadata.tags,
        duration: metadata.duration
      )
    end

    change_column_null :videos, :hd, false
    change_column_null :videos, :title, false
    change_column_null :videos, :description, false
    change_column_null :videos, :youtube_view_count, false
    change_column_null :videos, :youtube_like_count, false
    change_column_null :videos, :duration, false
  end

  def down
    change_column_null :videos, :title, true
    change_column_null :videos, :description, true
    change_column_null :videos, :youtube_view_count, true
    change_column_null :videos, :youtube_like_count, true
    change_column_null :videos, :duration, true
    change_column_null :videos, :hd, true

    remove_column :videos, :upload_date_year
    remove_column :videos, :title
    remove_column :videos, :description
    remove_column :videos, :hd
    remove_column :videos, :youtube_view_count
    remove_column :videos, :youtube_like_count
    remove_column :videos, :youtube_tags
    remove_column :videos, :duration
  end
end
