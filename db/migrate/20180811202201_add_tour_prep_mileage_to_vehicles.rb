class AddTourPrepMileageToVehicles < ActiveRecord::Migration[5.1]
  def change
    add_column :vehicles, :tour_car_prep, :boolean, default: false
    add_column :vehicles, :last_tour_car_prep_mileage, :float, default: 0.0
    add_column :vehicles, :tour_car_prep_interval, :float, default: 0.0
    add_column :vehicles, :near_tour_car_prep, :boolean, default: false
    add_column :vehicles, :near_tour_car_prep_mileage, :float, default: 0.0
  end
end
