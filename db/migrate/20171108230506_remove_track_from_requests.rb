class RemoveTrackFromRequests < ActiveRecord::Migration[5.1]
  def change
    remove_column :requests, :track, :string
  end
end
