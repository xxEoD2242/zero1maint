class AddVehicleCategoryIdToVehicle < ActiveRecord::Migration[5.1]
  def change
    add_column :vehicles, :vehicle_category_id, :integer
  end
end
