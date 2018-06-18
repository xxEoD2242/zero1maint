# frozen_string_literal: true

class AddMakeToVehicles < ActiveRecord::Migration[5.1]
  def change
    add_column :vehicles, :make, :string
  end
end
