# frozen_string_literal: true

class CreateTrackers < ActiveRecord::Migration[5.1]
  def change
    create_table :trackers do |t|
      t.string :track

      t.timestamps
    end
  end
end
