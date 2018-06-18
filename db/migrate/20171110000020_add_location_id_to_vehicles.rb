# frozen_string_literal: true

class AddLocationIdToVehicles < ActiveRecord::Migration[5.1]
  def change
    add_column :vehicles, :location_id, :integer
  end
end
