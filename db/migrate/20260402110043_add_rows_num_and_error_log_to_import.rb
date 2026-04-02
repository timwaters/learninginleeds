class AddRowsNumAndErrorLogToImport < ActiveRecord::Migration[5.2]
  def change
    add_column :imports, :rows_num, :integer
    add_column :imports, :error_log, :jsonb
  end
end
