class DropTableSearchSuggestions < ActiveRecord::Migration[6.1]
  def up
    drop_table :search_suggestions
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
