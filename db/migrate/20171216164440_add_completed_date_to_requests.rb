# frozen_string_literal: true

class AddCompletedDateToRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :requests, :completed_date, :date
  end
end
