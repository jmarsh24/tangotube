class RemoveCommentsFromExtensions < ActiveRecord::Migration[6.1]
  def change
    def up
      ActiveRecord::Base.connection.execute("COMMENT ON EXTENSION plpgsql IS NULL;") if Rails.env.development?
      ActiveRecord::Base.connection.execute("COMMENT ON EXTENSION fuzzystrmatch IS NULL;") if Rails.env.development?
      ActiveRecord::Base.connection.execute("COMMENT ON EXTENSION pg_trgm IS NULL;") if Rails.env.development?
      ActiveRecord::Base.connection.execute("COMMENT ON EXTENSION unaccent IS NULL;") if Rails.env.development?
    end

    def down
      ActiveRecord::Base.connection.execute("COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';") if Rails.env.development?
      ActiveRecord::Base.connection.execute("COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';") if Rails.env.development?
      ActiveRecord::Base.connection.execute("COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';") if Rails.env.development?
      ActiveRecord::Base.connection.execute("COMMENT ON EXTENSION unaccent IS 'text search dictionary that removes accents';") if Rails.env.development?
    end
  end
end
