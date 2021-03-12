class AddIndexToVideosYoutubeId < ActiveRecord::Migration[6.1]
  def change
    add_index :videos, :youtube_id
  end
end
