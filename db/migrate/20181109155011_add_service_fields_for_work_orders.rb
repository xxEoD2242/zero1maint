class AddServiceFieldsForWorkOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :requests, :a_service, :boolean, default: false
    add_column :requests, :shock_service, :boolean, default: false
    add_column :requests, :air_filter_service, :boolean, default: false
    add_column :requests, :tour_car_prep, :boolean, default: false
    add_column :requests, :defect, :boolean, default: false
    add_column :requests, :repairs, :boolean, default: false
  end
end
