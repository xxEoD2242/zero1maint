class AddWorkOrdersOverdueToVehicles < ActiveRecord::Migration[5.1]
  def change
    add_column :vehicles, :work_orders_overdue, :boolean, default: false
    add_column :requests, :deadline, :boolean, default: false
  end
end
