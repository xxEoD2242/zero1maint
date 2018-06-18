# frozen_string_literal: true

class AddPrepToVehicles < ActiveRecord::Migration[5.1]
  def change
    add_column :vehicles, :prep, :boolean
  end
end
