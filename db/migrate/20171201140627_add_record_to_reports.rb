# frozen_string_literal: true

class AddRecordToReports < ActiveRecord::Migration[5.1]
  def change
    add_column :reports, :record, :string
  end
end
