# frozen_string_literal: true

class RemoveEventIdFromVehicles < ActiveRecord::Migration[5.1]
  def change
    remove_column :vehicles, :event_id, :integer
  end
end
