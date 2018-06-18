# frozen_string_literal: true

class CreateReportVehicles < ActiveRecord::Migration[5.1]
  def change
    create_table :report_vehicles do |t|
      t.integer :report_id
      t.integer :vehicle_id

      t.timestamps
    end
  end
end
