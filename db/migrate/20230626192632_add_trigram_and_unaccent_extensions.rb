class AddTrigramAndUnaccentExtensions < ActiveRecord::Migration[7.1]
  def change
    enable_extension "pg_trgm"
    enable_extension "unaccent"
  end
end
