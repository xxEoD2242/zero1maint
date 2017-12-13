class AddVehCategoryToVehicles < ActiveRecord::Migration[5.1]
  def change
    add_column :vehicles, :veh_category, :string
  end
end
