class AddDefectToVehicles < ActiveRecord::Migration[5.1]
  def change
    add_column :vehicles, :defect, :boolean
  end
end
