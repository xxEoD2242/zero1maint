# frozen_string_literal: true

class AddNearServiceToVehicles < ActiveRecord::Migration[5.1]
  def change
    add_column :vehicles, :near_service, :boolean
  end
end
