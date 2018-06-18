# frozen_string_literal: true

class AddTrackIdToRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :requests, :track_id, :integer
  end
end
