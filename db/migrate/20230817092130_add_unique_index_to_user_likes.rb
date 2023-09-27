# frozen_string_literal: true

class AddUniqueIndexToUserLikes < ActiveRecord::Migration[7.0]
  def change
    add_index :likes, ["user_id", "likeable_type", "likeable_id"], unique: true, name: "index_likes_on_user_and_likeable"
  end
end
