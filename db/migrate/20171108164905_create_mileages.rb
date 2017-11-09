class CreateMileages < ActiveRecord::Migration[5.1]
  def change
    create_table :mileages do |t|
      t.float :mileage

      t.timestamps
    end
  end
end
