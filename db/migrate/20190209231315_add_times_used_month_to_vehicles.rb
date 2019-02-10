class AddTimesUsedMonthToVehicles < ActiveRecord::Migration[5.1]
  def change
    add_column :vehicles, :times_used_year, :integer, default: 0
  end
end
