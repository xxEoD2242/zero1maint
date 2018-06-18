# frozen_string_literal: true

class CreateRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :requests do |t|
      t.integer :number
      t.text :description
      t.string :status
      t.text :special_requets
      t.date :completion_date
      t.string :poc

      t.timestamps
    end
  end
end
