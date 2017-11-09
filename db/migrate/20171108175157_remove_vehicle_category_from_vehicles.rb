class RemoveVehicleCategoryFromVehicles < ActiveRecord::Migration[5.1]
  def change
    remove_column :vehicles, :vehicle_category, :string
  end
end
