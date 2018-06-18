# frozen_string_literal: true

class AddVehicleCategoryIdToParts < ActiveRecord::Migration[5.1]
  def change
    add_column :parts, :vehicle_category_id, :integer
  end
end
