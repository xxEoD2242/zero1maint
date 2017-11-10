class CreateEventsVehicles < ActiveRecord::Migration[5.1]
  def change
    create_table :events_vehicles do |t|
      t.integer :event_id
      t.integer :vehicle_id

      t.timestamps
    end
  end
end
