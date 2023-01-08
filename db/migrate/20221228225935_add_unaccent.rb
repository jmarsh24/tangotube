# frozen_string_literal: true

class AddUnaccent < ActiveRecord::Migration[7.0]
  def change
    enable_extension "unaccent"
  end
end
