# frozen_string_literal: true

class RemoveFeaturedFromVideos < ActiveRecord::Migration[7.0]
  def change
    remove_column :videos, :featured
  end
end
