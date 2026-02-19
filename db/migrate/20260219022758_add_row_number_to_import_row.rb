class AddRowNumberToImportRow < ActiveRecord::Migration[8.1]
  def change
    add_column :import_rows, :row, :integer
  end
end
