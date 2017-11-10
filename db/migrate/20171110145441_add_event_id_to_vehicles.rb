class AddEventIdToVehicles < ActiveRecord::Migration[5.1]
  def change
    add_column :vehicles, :event_id, :integer
  end
end
