class AddMileageIdToVehicles < ActiveRecord::Migration[5.1]
  def change
    add_column :vehicles, :mileage_id, :integer
  end
end
