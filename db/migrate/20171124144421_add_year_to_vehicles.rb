# frozen_string_literal: true

class AddYearToVehicles < ActiveRecord::Migration[5.1]
  def change
    add_column :vehicles, :year, :integer
  end
end
