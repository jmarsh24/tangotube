class AddUnaccentdict < ActiveRecord::Migration[6.1]
  def up
    execute <<-SQL

    CREATE TEXT SEARCH CONFIGURATION unaccentdict ( COPY = simple );

    ALTER TEXT SEARCH CONFIGURATION unaccentdict
    ALTER MAPPING FOR hword, hword_part, word
    WITH unaccent, simple;
    SQL
  end

  def down
    DROP TEXT SEARCH CONFIGURATION unaccentdict;
  end
end
