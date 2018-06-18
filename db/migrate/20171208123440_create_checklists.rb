# frozen_string_literal: true

class CreateChecklists < ActiveRecord::Migration[5.1]
  def change
    create_table :checklists do |t|
      t.integer :vehicle_id
      t.integer :user_id
      t.string :fuel_level
      t.string :wash
      t.string :suspension
      t.string :drive_train
      t.string :body
      t.string :engine
      t.string :brake
      t.string :safety_equipment
      t.string :chassis
      t.string :electrical
      t.string :cooling_system
      t.string :tires
      t.string :radio
      t.string :exhaust
      t.string :steering
      t.text :comments

      t.timestamps
    end
  end
end
