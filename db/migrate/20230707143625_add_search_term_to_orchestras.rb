# frozen_string_literal: true

class AddSearchTermToOrchestras < ActiveRecord::Migration[7.0]
  def change
    add_column :orchestras, :search_term, :string
  end
end
