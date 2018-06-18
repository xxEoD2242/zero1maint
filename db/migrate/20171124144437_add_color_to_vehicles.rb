# frozen_string_literal: true

class AddColorToVehicles < ActiveRecord::Migration[5.1]
  def change
    add_column :vehicles, :color, :string
  end
end
