class AddNameToChecklists < ActiveRecord::Migration[5.1]
  def change
    add_column :checklists, :name, :string
    remove_table :VehicleCategories
  end
end
