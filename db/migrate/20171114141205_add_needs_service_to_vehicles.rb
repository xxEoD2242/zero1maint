# frozen_string_literal: true

class AddNeedsServiceToVehicles < ActiveRecord::Migration[5.1]
  def change
    add_column :vehicles, :needs_service, :boolean
  end
end
