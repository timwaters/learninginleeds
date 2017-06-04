class EnableAdditionalPgSearchPostgresExtensions < ActiveRecord::Migration[5.1]
  def change
    enable_extension "pg_trgm"
    enable_extension "fuzzystrmatch"
  end
end
