class RemoveCategoryFromVehicles < ActiveRecord::Migration[5.1]
  def change
    remove_column :vehicles, :category, :string
  end
end
