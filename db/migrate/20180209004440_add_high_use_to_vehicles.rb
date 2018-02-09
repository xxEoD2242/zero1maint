class AddHighUseToVehicles < ActiveRecord::Migration[5.1]
  def change
    add_column :vehicles, :high_use, :boolean
  end
end
