class RemoveCommentOnExtensionPostgresForHeroku < ActiveRecord::Migration[6.1]
  def up
    if Rails.env.development?
      ActiveRecord::Base.connection.execute(
        'COMMENT ON EXTENSION plpgsql IS NULL;'
      )
    end
  end

  def down
    if Rails.env.development?
      ActiveRecord::Base.connection.execute(
        "COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';"
      )
    end
  end
end
