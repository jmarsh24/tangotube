class AddUseTrigramToDancers < ActiveRecord::Migration[7.1]
  def change
    add_column :dancers, :use_trigram, :boolean, default: true, null: false
  end
end
