# frozen_string_literal: true

class RemoveRequestIdFromVehicles < ActiveRecord::Migration[5.1]
  def change
    remove_column :vehicles, :request_id, :integer
  end
end
