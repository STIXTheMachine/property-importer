class CreateImportRows < ActiveRecord::Migration[8.1]
  def change
    create_table :import_rows do |t|
      t.string :building_name
      t.string :street_address
      t.string :unit
      t.string :city
      t.string :state
      t.string :zip
      t.references :import, null: false, foreign_key: true

      t.timestamps
    end
  end
end
