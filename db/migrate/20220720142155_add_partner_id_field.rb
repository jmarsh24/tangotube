class AddPartnerIdField < ActiveRecord::Migration[7.0]
  def change
    add_reference :couples, :partner, references: :dancers, foreign_key: {to_table: :dancers}
  end
end
