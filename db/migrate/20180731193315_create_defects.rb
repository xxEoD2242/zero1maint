# frozen_string_literal: true

class CreateDefects < ActiveRecord::Migration[5.1]
  def change
    create_table :defects do |t|
      t.string :description, default: ''
      t.string :category, default: ''
      t.belongs_to :vehicle
      t.belongs_to :checklist
      t.boolean :fixed, default: false
      t.date :date_fixed, default: Date.current

      t.timestamps
    end
  end
end
