# frozen_string_literal: true

class CreateContacts < ActiveRecord::Migration[7.1]
  def change
    create_table :contacts, id: :uuid do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.text :message, null: false
      t.timestamps
    end
  end
end
