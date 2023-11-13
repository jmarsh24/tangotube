# frozen_string_literal: true

class AddIndexChannelsYoutubeSlug < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    add_index :channels, :youtube_slug, unique: true, algorithm: :concurrently
  end
end
