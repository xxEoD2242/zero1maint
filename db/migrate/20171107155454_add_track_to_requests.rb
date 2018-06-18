# frozen_string_literal: true

class AddTrackToRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :requests, :track, :string
  end
end
