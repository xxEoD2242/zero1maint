# frozen_string_literal: true

class AddSaleDateToVehicles < ActiveRecord::Migration[5.1]
  def change
    add_column :vehicles, :sale_date, :date
    add_column :vehicles, :purchaser, :string
  end
end
