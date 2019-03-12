class DropVehicleCategories < ActiveRecord::Migration[5.1]
  def change
    drop_table :vehicle_categories
  end
end
