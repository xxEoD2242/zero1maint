class CreateVehicles < ActiveRecord::Migration[5.1]
  def change
    create_table :vehicles do |t|
      t.string :car_id
      t.integer :car_category_id
      t.string :manufacturer
      t.integer :status
      t.string :vin_number
      t.date :registration_date
      t.string :plate_number
      t.integer :request_id
      t.integer :mileage_id

      t.timestamps
    end
  end
end
