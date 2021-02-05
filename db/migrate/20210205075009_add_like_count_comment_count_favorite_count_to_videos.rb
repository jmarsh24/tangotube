class AddLikeCountCommentCountFavoriteCountToVideos < ActiveRecord::Migration[6.1]
  def change
    add_column :videos, :like_count, :integer, default: 0
    add_column :videos, :dislike_count, :integer, default: 0
    add_column :videos, :favorite_count, :integer, default: 0
    add_column :videos, :comment_count, :integer, default: 0
  end
end
