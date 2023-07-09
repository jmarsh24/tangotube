# frozen_string_literal: true

class AddIndexesForVideoSearch < ActiveRecord::Migration[7.1]
  def change
    add_index :videos, :upload_date
    add_index :videos, :click_count
    add_index :dancers, :slug
    add_index :orchestras, :slug
  end
end
