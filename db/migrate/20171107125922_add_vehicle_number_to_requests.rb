# frozen_string_literal: true

class AddVehicleNumberToRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :requests, :vehicle_number, :integer
  end
end
