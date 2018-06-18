# frozen_string_literal: true

class AddAirFilterServiceToVehicles < ActiveRecord::Migration[5.1]
  def change
    add_column :vehicles, :air_filter_service, :boolean
  end
end
