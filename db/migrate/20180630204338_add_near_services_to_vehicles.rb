class AddNearServicesToVehicles < ActiveRecord::Migration[5.1]
  def change
    add_column :vehicles, :near_a_service, :boolean, default: false
    add_column :vehicles, :near_shock_service, :boolean, default: false
    add_column :vehicles, :near_air_filter_service, :boolean, default: false
    add_column :vehicles, :near_a_service_mileage, :float, default: 0.0
    add_column :vehicles, :near_shock_service_mileage, :float, default: 0.0
    add_column :vehicles, :near_air_filter_service_mileage, :float, default: 0.0
  end
end
