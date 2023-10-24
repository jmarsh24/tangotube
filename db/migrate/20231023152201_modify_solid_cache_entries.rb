# frozen_string_literal: true

class ModifySolidCacheEntries < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    safety_assured {
      execute "ALTER TABLE solid_cache_entries SET UNLOGGED;"
    }
    remove_index :solid_cache_entries, :key

    add_index :solid_cache_entries, :key, using: "hash", algorithm: :concurrently
  end
end
