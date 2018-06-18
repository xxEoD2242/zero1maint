# frozen_string_literal: true

class AddVehicleIdToRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :requests, :vehicle_id, :integer
  end
end
