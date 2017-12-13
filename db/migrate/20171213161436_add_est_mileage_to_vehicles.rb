class AddEstMileageToVehicles < ActiveRecord::Migration[5.1]
  def change
    add_column :vehicles, :est_mileage, :float
  end
end
