class AddInfoVehicleToReports < ActiveRecord::Migration[5.1]
  def change
    add_column :reports, :info_vehicle, :text
  end
end
