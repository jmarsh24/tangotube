# frozen_string_literal: true

class CreateRecentSearches < ActiveRecord::Migration[7.0]
  def change
    create_table :recent_searches, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true
      t.references :searchable, polymorphic: true, index: true
      t.string :query
      t.string :category

      t.timestamps
    end
  end
end
