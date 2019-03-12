class AddMultiVehicleToRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :requests, :multi_vehicle, :boolean, default: false
  end
end
