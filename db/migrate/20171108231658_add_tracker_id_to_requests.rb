# frozen_string_literal: true

class AddTrackerIdToRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :requests, :tracker_id, :integer
  end
end
