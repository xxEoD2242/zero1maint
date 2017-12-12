class AddUseNearServiceToVehicles < ActiveRecord::Migration[5.1]
  def change
    add_column :vehicles, :use_near_service, :boolean
  end
end
