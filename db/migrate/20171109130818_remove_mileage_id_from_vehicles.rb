class RemoveMileageIdFromVehicles < ActiveRecord::Migration[5.1]
  def change
    remove_column :vehicles, :mileage_id, :integer
  end
end
