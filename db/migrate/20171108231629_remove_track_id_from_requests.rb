# frozen_string_literal: true

class RemoveTrackIdFromRequests < ActiveRecord::Migration[5.1]
  def change
    remove_column :requests, :track_id, :integer
  end
end
