# frozen_string_literal: true

class AddRequestMilesToReportVehicleOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :report_vehicle_orders, :request_miles, :text
  end
end
