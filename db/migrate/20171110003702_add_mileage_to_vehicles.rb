# frozen_string_literal: true

class AddMileageToVehicles < ActiveRecord::Migration[5.1]
  def change
    add_column :vehicles, :mileage, :float
  end
end
