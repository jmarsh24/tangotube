# frozen_string_literal: true

class AddActiveIndexToChannels < ActiveRecord::Migration[7.0]
  def change
    add_index :channels, :active
  end
end
