# frozen_string_literal: true

class RemoveCarCategoryIdFromVehicle < ActiveRecord::Migration[5.1]
  def change
    remove_column :vehicles, :car_category_id, :integer
  end
end
