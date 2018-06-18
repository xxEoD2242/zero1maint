# frozen_string_literal: true

class RemoveStatusFromVehicles < ActiveRecord::Migration[5.1]
  def change
    remove_column :vehicles, :status, :string
  end
end
