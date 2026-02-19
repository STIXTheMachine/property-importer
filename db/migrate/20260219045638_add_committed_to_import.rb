class AddCommittedToImport < ActiveRecord::Migration[8.1]
  def change
    add_column :imports, :committed, :boolean, default: false, null: false
  end
end
