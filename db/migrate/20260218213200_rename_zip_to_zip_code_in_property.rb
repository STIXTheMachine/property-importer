class RenameZipToZipCodeInProperty < ActiveRecord::Migration[8.1]
  def change
    rename_column :properties, :zip, :zip_code
  end
end
