# frozen_string_literal: true

class RemoveSolidCacheKeyHashIndex < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    remove_index :solid_cache_entries, :key
    add_index :solid_cache_entries, :key, unique: true, algorithm: :concurrently
  end
end
