# frozen_string_literal: true

class FixCoupleOrdering < ActiveRecord::Migration[7.0]
  def up
    swap_couples = Couple.where("dancer_id > partner_id")

    swap_couples.find_each do |couple|
      ordered_dancer_id = couple.partner_id
      ordered_partner_id = couple.dancer_id

      inverse_couple = Couple.find_by(dancer_id: ordered_dancer_id, partner_id: ordered_partner_id)

      if inverse_couple
        couple.destroy
      else
        couple.update_columns(dancer_id: ordered_dancer_id, partner_id: ordered_partner_id)
      end
    end
  end
end
