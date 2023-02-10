# frozen_string_literal: true

class AddUniqueConstraintsDeleteRequest < ActiveRecord::Migration[7.0]
  def change
    add_index :deletion_requests, [:uid, :provider], unique: true
  end
end
