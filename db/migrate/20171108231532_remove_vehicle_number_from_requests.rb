class RemoveVehicleNumberFromRequests < ActiveRecord::Migration[5.1]
  def change
    remove_column :requests, :vehicle_number, :string
  end
end
