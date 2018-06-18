# frozen_string_literal: true

class AddVehicleStatusToReportVehicles < ActiveRecord::Migration[5.1]
  def change
    add_column :report_vehicles, :vehicle_status, :string
  end
end
