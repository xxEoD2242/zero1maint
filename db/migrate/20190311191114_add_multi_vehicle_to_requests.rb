class AddMultiVehicleToRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :requests, :multi_vehicle, :boolean, default: false
    remove_column :requests, :special_requets, :text
    remove_column :requests, :tracker_id, :integer
    remove_column :requests, :checklist_numb, :integer
  end
end
