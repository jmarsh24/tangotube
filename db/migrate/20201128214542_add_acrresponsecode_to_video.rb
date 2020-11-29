class AddAcrresponsecodeToVideo < ActiveRecord::Migration[6.0]
  def change
    add_column :videos, :acr_response_code, :integer
  end
end
