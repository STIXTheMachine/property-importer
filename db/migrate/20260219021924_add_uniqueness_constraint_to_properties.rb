class AddUniquenessConstraintToProperties < ActiveRecord::Migration[8.1]
  def change
    add_index :properties, :building_name, unique: true
  end
end
