class RenameZipToZipCodeInImportRows < ActiveRecord::Migration[8.1]
  def change
    rename_column :import_rows, :zip, :zip_code
  end
end
