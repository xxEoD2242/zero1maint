class CreateReportVehicleOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :report_vehicle_orders do |t|
      t.integer :car_id
      t.integer :report_id
      t.boolean :needs_service
      t.boolean :near_service
      t.boolean :a_service
      t.boolean :shock_service
      t.boolean :air_filter_service
      t.boolean :repair_needed
      t.boolean :defect
      t.string :location
      t.string :vehicle_category
      t.float :mileage

      t.timestamps
    end
  end
end
