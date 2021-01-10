class PostgresExtentionProduction < ActiveRecord::Migration[6.1]
def up
  ActiveRecord::Base.connection.execute("COMMENT ON EXTENSION plpgsql IS NULL;") if Rails.env.development?
end

def down
  ActiveRecord::Base.connection.execute("COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';") if Rails.env.development?
end
end
