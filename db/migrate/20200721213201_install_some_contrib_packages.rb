class InstallSomeContribPackages < ActiveRecord::Migration[6.0]
  def up
    execute "CREATE EXTENSION IF NOT EXISTS pg_trgm;"
    execute "CREATE EXTENSION IF NOT EXISTS fuzzystrmatch;"
    execute "CREATE EXTENSION IF NOT EXISTS unaccent;"
  end

  def down
    execute "DROP EXTENSION IF EXISTS pg_trgm;"
    execute "DROP EXTENSION IF EXISTS fuzzystrmatch;"
    execute "DROP EXTENSION IF EXISTS unaccent;"
  end
end
