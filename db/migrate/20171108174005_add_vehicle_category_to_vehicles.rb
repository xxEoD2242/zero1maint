# frozen_string_literal: true

class AddVehicleCategoryToVehicles < ActiveRecord::Migration[5.1]
  def change
    add_column :vehicles, :vehicle_category, :string
  end
end
