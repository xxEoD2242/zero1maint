# frozen_string_literal: true

class CreatePartItems < ActiveRecord::Migration[5.1]
  def change
    create_table :part_items do |t|
      t.integer :part_id
      t.integer :order_id
      t.integer :quantity

      t.timestamps
    end
  end
end
