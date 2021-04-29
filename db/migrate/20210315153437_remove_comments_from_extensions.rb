class RemoveCommentsFromExtensions < ActiveRecord::Migration[6.1]
  def change
    def up
      if Rails.env.development?
        ActiveRecord::Base.connection.execute(
          'COMMENT ON EXTENSION plpgsql IS NULL;'
        )
      end
      if Rails.env.development?
        ActiveRecord::Base.connection.execute(
          'COMMENT ON EXTENSION fuzzystrmatch IS NULL;'
        )
      end
      if Rails.env.development?
        ActiveRecord::Base.connection.execute(
          'COMMENT ON EXTENSION pg_trgm IS NULL;'
        )
      end
      if Rails.env.development?
        ActiveRecord::Base.connection.execute(
          'COMMENT ON EXTENSION unaccent IS NULL;'
        )
      end
    end

    def down
      if Rails.env.development?
        ActiveRecord::Base.connection.execute(
          "COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';"
        )
      end
      if Rails.env.development?
        ActiveRecord::Base.connection.execute(
          "COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';"
        )
      end
      if Rails.env.development?
        ActiveRecord::Base.connection.execute(
          "COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';"
        )
      end
      if Rails.env.development?
        ActiveRecord::Base.connection.execute(
          "COMMENT ON EXTENSION unaccent IS 'text search dictionary that removes accents';"
        )
      end
    end
  end
end
