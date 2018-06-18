# frozen_string_literal: true

class CreatePartReports < ActiveRecord::Migration[5.1]
  def change
    create_table :part_reports do |t|
      t.integer :part_id
      t.integer :report_id

      t.timestamps
    end
  end
end
