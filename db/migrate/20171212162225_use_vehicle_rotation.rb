class UseVehicleRotation < ActiveRecord::Migration[5.1]
  def change
    add_column :vehicles, :use, :boolean
    add_column :vehicles, :dont_use_a_service, :boolean
    add_column :vehicles, :dont_use_shock_service, :boolean
    add_column :vehicles, :dont_use_air_filter_service, :boolean
  end
end
