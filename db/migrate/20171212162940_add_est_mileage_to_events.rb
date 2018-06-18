# frozen_string_literal: true

class AddEstMileageToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :est_mileage, :float
  end
end
