# frozen_string_literal: true

class ConvertDancerNickNamesToArray < ActiveRecord::Migration[7.0]
  def up
    change_column :dancers, :nick_name, :string, array: true, default: [], using: "(string_to_array(nick_name, ','))"
  end

  def down
    change_column :dancers, :nick_name, :string, array: false, using: "(array_to_string(nick_name, ','))"
  end
end
