# frozen_string_literal: true

class AddGenderToDancers < ActiveRecord::Migration[7.0]
  def change
    add_column :dancers, :gender, :integer
  end
end
