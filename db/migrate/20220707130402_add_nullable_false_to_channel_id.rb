# frozen_string_literal: true

class AddNullableFalseToChannelId < ActiveRecord::Migration[7.0]
  def change
    change_column :channels, :channel_id, :string, null: false, unique: true
  end
end
