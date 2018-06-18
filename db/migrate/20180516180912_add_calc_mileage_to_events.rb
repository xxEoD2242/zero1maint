# frozen_string_literal: true

class AddCalcMileageToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :calc_mileage, :float
  end
end
