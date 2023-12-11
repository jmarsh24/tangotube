# frozen_string_literal: true

class AddNormalizedNameToDancers < ActiveRecord::Migration[7.1]
  def change
    add_column :dancers, :normalized_name, :string
  end
end
