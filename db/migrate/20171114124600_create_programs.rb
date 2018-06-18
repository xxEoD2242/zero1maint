# frozen_string_literal: true

class CreatePrograms < ActiveRecord::Migration[5.1]
  def change
    create_table :programs do |t|
      t.string :name
      t.float :interval

      t.timestamps
    end
  end
end
