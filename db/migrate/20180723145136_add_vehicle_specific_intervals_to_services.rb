class AddVehicleSpecificIntervalsToServices < ActiveRecord::Migration[5.1]
  def change
    add_column :programs, :rzr_interval, :float, default: 0.0
    add_column :programs, :tour_car_interval, :float, default: 0.0
    add_column :programs, :fleet_interval, :float, default: 0.0
    add_column :programs, :training_interval, :float, default: 0.0
    add_column :programs, :other_interval, :float, default: 0.0
    add_column :programs, :db_interval, :float, default: 0.0
    add_column :vehicles, :a_service_interval, :float, default: 0.0
    add_column :vehicles, :shock_service_interval, :float, default: 0.0
    add_column :vehicles, :air_filter_service_interval, :float, default: 0.0
    remove_column :vehicles, :vehicle_category_id, :integer
    remove_column :programs, :interval, :float
    remove_column :programs, :completed, :boolean
  end
end
