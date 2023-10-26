# frozen_string_literal: true

class DropSolidCache < ActiveRecord::Migration[7.1]
  def change
    drop_table :solid_cache_entries
  end
end
