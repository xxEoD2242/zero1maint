# frozen_string_literal: true

class AddVehicleStatusToVehicles < ActiveRecord::Migration[5.1]
  def change
    add_column :vehicles, :vehicle_status, :string
  end
end
