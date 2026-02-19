class SetDefaultValidatedOnImports < ActiveRecord::Migration[8.1]
  def change
    change_column_default :imports, :validated, false
  end
end
