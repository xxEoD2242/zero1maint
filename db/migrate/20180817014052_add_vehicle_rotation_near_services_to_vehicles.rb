class AddVehicleRotationNearServicesToVehicles < ActiveRecord::Migration[5.1]
  def change
    add_column :vehicles, :dont_use_near_a_service, :boolean, default: false
    add_column :vehicles, :dont_use_near_shock_service, :boolean, default: false
    add_column :vehicles, :dont_use_near_air_filter_service, :boolean, default: false
    add_column :vehicles, :dont_use_near_tour_car_prep, :boolean, default: false
    add_column :vehicles, :dont_use_near_a_service_mileage, :float, default: 0.0
    add_column :vehicles, :dont_use_near_shock_service_mileage, :float, default: 0.0
    add_column :vehicles, :dont_use_near_air_filter_service_mileage, :float, default: 0.0
    add_column :vehicles, :dont_use_near_tour_car_prep_mileage, :float, default: 0.0
    add_column :vehicles, :dont_use_tour_car_prep, :boolean, default: false
  end
end
