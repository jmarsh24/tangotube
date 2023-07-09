# frozen_string_literal: true

class CreateWatches < ActiveRecord::Migration[7.0]
  def change
    create_table :watches, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true
      t.references :video, null: false, foreign_key: true
      t.datetime :watched_at

      t.timestamps
    end
  end
end
