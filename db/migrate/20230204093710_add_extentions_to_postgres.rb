# frozen_string_literal: true

class AddExtentionsToPostgres < ActiveRecord::Migration[7.0]
  def change
    enable_extension :pg_trgm
    enable_extension :btree_gin
    enable_extension :unaccent
  end
end
