# frozen_string_literal: true

class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.datetime :date
      t.float :event_mileage
      t.integer :location_id
      t.float :duration
      t.string :event_type
      t.string :class_type

      t.timestamps
    end
  end
end
