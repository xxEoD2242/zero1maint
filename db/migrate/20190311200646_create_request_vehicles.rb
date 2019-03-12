class CreateRequestVehicles < ActiveRecord::Migration[5.1]
  def change
    create_table :request_vehicles do |t|
      t.integer :request_id
      t.integer :vehicle_id

      t.timestamps
    end
  end
end
