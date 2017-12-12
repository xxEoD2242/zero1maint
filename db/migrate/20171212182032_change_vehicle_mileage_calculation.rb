class ChangeVehicleMileageCalculation < ActiveRecord::Migration[5.1]
  def change
    add_column :vehicles, :last_a_service, :float
    add_column :vehicles, :last_sock_service, :float
    add_column :vehicles, :last_air_filter_service, :float
  end
end
