# frozen_string_literal: true

class AddSearchTextToDancerAndUser < ActiveRecord::Migration[7.1]
  def change
    add_column :dancers, :search_text, :text
    add_column :users, :search_text, :text
    add_column :dancers, :match_terms, :text, array: true, default: []
    add_column :dancers, :nickname, :string

    remove_column :dancers, :nick_name, :string
    remove_column :dancers, :first_name, :string
    remove_column :dancers, :last_name, :string
    remove_column :dancers, :middle_name, :string

    add_index :dancers, :search_text, using: :gist, opclass: :gist_trgm_ops
    add_index :users, :search_text, using: :gist, opclass: :gist_trgm_ops
  end
end
