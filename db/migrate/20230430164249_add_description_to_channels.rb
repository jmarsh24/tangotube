# frozen_string_literal: true

class AddDescriptionToChannels < ActiveRecord::Migration[7.0]
  def change
    add_column :channels, :description, :text
  end
end
