class AddVehicleIdToMileage < ActiveRecord::Migration[5.1]
  def change
    add_column :mileages, :vehicle_id, :integer
  end
end
