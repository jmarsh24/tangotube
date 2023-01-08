# frozen_string_literal: true

class AddGiphyidToClip < ActiveRecord::Migration[7.0]
  def change
    add_column :clips, :giphy_id, :string
  end
end
