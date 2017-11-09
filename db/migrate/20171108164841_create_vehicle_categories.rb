class CreateVehicleCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :vehicle_categories do |t|
      t.string :name

      t.timestamps
    end
  end
end
