# frozen_string_literal: true

class RemoveVotes < ActiveRecord::Migration[7.1]
  def change
    drop_table :votes
  end
end
