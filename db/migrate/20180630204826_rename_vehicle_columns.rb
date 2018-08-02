# frozen_string_literal: true

class RenameVehicleColumns < ActiveRecord::Migration[5.1]
  def change
    change_column :vehicles, :car_id, :string, default: 'Blank'
    change_column :vehicles, :manufacturer, :string, default: 'Blank'
    change_column :vehicles, :vin_number, :string, default: 'Blank'
    change_column :vehicles, :registration_date, :date, default: Time.now
    change_column :vehicles, :plate_number, :string, default: 'Blank'
    change_column :vehicles, :vehicle_status, :string, default: 'In-Service'
    change_column :vehicles, :needs_service, :boolean, default: false
    change_column :vehicles, :near_service, :boolean, default: false
    change_column :vehicles, :a_service, :boolean, default: false
    change_column :vehicles, :shock_service, :boolean, default: false
    change_column :vehicles, :air_filter_service, :boolean, default: false
    change_column :vehicles, :repair_needed, :boolean, default: false
    change_column :vehicles, :defect, :boolean, default: false
    change_column :vehicles, :near_service, :boolean, default: false
    change_column :vehicles, :make, :string, default: 'Blank'
    change_column :vehicles, :color, :string, default: 'Blank'
    change_column :vehicles, :year, :integer, default: 0
    change_column :vehicles, :use_a, :boolean, default: false
    change_column :vehicles, :use_b, :boolean, default: false
    change_column :vehicles, :dont_use_a_service, :boolean, default: false
    change_column :vehicles, :dont_use_shock_service, :boolean, default: false
    change_column :vehicles, :dont_use_air_filter_service, :boolean, default: false
    change_column :vehicles, :use_near_service, :boolean, default: false
    change_column :vehicles, :last_a_service, :float, default: 0.0
    change_column :vehicles, :last_shock_service, :float, default: 0.0
    change_column :vehicles, :last_air_filter_service, :float, default: 0.0
    change_column :vehicles, :times_used, :integer, default: 0.0
    change_column :vehicles, :veh_category, :string, default: 'RZR'
    change_column :vehicles, :location, :string, default: 'RZR Basecamp'
    change_column :vehicles, :high_use, :boolean, default: false
    change_column :vehicles, :notes, :string, default: 'Blank'
    change_column :vehicles, :purchaser, :string, default: 'Blank'
    change_column :vehicles, :sale_date, :date, default: Time.now
    change_column :vehicles, :prep, :boolean, default: false
  end
end
