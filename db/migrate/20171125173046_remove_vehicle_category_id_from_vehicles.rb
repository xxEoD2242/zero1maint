class RemoveVehicleCategoryIdFromVehicles < ActiveRecord::Migration[5.1]
  def change
    remove_column :vehicles, :vehicle_category_id, :integer
  end
end
