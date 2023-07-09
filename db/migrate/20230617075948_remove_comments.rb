# frozen_string_literal: true

class RemoveComments < ActiveRecord::Migration[7.0]
  def change
    drop_table :comments
  end
end
