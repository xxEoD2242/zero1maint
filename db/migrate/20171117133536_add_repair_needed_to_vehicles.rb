# frozen_string_literal: true

class AddRepairNeededToVehicles < ActiveRecord::Migration[5.1]
  def change
    add_column :vehicles, :repair_needed, :boolean
  end
end
