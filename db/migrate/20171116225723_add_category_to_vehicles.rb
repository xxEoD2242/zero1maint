class AddCategoryToVehicles < ActiveRecord::Migration[5.1]
  def change
    add_column :vehicles, :category, :string
  end
end
