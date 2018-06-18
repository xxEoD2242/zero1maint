# frozen_string_literal: true

class AddVehicleStatusToReportVehicleOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :report_vehicle_orders, :vehicle_status, :string
  end
end
