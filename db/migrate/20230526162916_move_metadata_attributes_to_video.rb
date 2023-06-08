class MoveMetadataAttributesToVideo < ActiveRecord::Migration[7.1]  
  def change
    change_column_null :videos, :title, false
    change_column_null :videos, :description, false
    change_column_null :videos, :hd, false
    change_column_null :videos, :youtube_view_count, false
    change_column_null :videos, :youtube_like_count, false
    change_column_null :videos, :duration, false

    change_column_default :videos, :upload_date_year, 0
    change_column_default :videos, :hd, false
    change_column_default :videos, :youtube_view_count, 0
    change_column_default :videos, :youtube_like_count, 0
    change_column_default :videos, :youtube_tags, []
    change_column_default :videos, :duration, 0
  end
end
