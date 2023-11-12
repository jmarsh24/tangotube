# frozen_string_literal: true

class AddIndexNormalizedTitle < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def up
    safety_assured {
      execute "SET statement_timeout = 0"
      add_index :videos, :normalized_title, opclass: :gin_trgm_ops, using: :gin, algorithm: :concurrently
      execute "SET statement_timeout = '60000'"
    }
  end

  def down
    remove_index :videos, :normalized_title
  end
end
