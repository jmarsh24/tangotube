# frozen_string_literal: true

class AddUniqueCoupleIdToCouple < ActiveRecord::Migration[7.0]
  def change
    add_column :couples, :unique_couple_id, :string
    add_index :couples, :unique_couple_id
    Couple.all.find_each do |couple|
      couple.unique_couple_id = [couple.dancer_id, couple.partner_id].sort.map(&:to_s).join("|")
      couple.save
    end
  end
end
