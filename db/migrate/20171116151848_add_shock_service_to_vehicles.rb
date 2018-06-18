# frozen_string_literal: true

class AddShockServiceToVehicles < ActiveRecord::Migration[5.1]
  def change
    add_column :vehicles, :shock_service, :boolean
  end
end
