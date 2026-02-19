class AddValidatedToImport < ActiveRecord::Migration[8.1]
  def change
    add_column :imports, :validated, :boolean
  end
end
