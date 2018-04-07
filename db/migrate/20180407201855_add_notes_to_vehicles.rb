class AddNotesToVehicles < ActiveRecord::Migration[5.1]
  def change
    add_column :vehicles, :notes, :text
  end
end
