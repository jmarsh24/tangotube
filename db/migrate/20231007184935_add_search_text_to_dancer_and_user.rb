# frozen_string_literal: true

class AddSearchTextToDancerAndUser < ActiveRecord::Migration[7.1]
  def change
    add_column :dancers, :search_text, :text
    add_column :users, :search_text, :text
    add_column :dancers, :match_terms, :text, array: true, default: []
    add_column :dancers, :nickname, :string

    Dancer.find_each do |dancer|
      next unless dancer.nick_name && dancer.nick_name.length > 2

      nicknames_array = dancer.nick_name[1..-2].split(",").map do |item|
        if item.is_a?(Array)
          item.first.tr('"', "").strip
        else
          item.tr('"', "").strip
        end
      end

      next unless nicknames_array.all? { |name| name.is_a?(String) }

      dancer.match_terms = nicknames_array.map { |name| Dancer.normalize(name) }
      dancer.save!
    end

    remove_column :dancers, :nick_name, :string
    remove_column :dancers, :first_name, :string
    remove_column :dancers, :last_name, :string
    remove_column :dancers, :middle_name, :string

    add_index :dancers, :search_text, using: :gist, opclass: :gist_trgm_ops
    add_index :users, :search_text, using: :gist, opclass: :gist_trgm_ops
    Dancer.all.each(&:save!)
  end
end
