# frozen_string_literal: true

class AddVehicleCategoryToParts < ActiveRecord::Migration[5.1]
  def change
    add_column :parts, :vehicle_category, :string
  end
end
