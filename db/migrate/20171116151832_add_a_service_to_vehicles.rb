# frozen_string_literal: true

class AddAServiceToVehicles < ActiveRecord::Migration[5.1]
  def change
    add_column :vehicles, :a_service, :boolean
  end
end
