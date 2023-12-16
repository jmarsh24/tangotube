# frozen_string_literal: true

class AddIndexToCategoryEnum < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    add_index :videos, :category, algorithm: :concurrently
  end
end
