# frozen_string_literal: true

class CreatePatreonEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :patreon_events, id: :uuid do |t|
      t.string :event_type
      t.jsonb :data

      t.timestamps
    end
  end
end
