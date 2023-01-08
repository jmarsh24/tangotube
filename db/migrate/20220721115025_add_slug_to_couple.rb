# frozen_string_literal: true

class AddSlugToCouple < ActiveRecord::Migration[7.0]
  def change
    add_column :couples, :slug, :string
  end
end
