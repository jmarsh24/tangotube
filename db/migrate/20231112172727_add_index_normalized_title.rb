# frozen_string_literal: true

class AddIndexNormalizedTitle < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    add_index :videos, :normalized_title, opclass: :gin_trgm_ops, using: :gin, algorithm: :concurrently
  end
end
