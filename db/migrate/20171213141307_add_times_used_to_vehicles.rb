# frozen_string_literal: true

class AddTimesUsedToVehicles < ActiveRecord::Migration[5.1]
  def change
    add_column :vehicles, :times_used, :integer
  end
end
