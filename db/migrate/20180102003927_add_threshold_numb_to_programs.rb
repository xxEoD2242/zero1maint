# frozen_string_literal: true

class AddThresholdNumbToPrograms < ActiveRecord::Migration[5.1]
  def change
    add_column :programs, :threshold_numb, :float
  end
end
