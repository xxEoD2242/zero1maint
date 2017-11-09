class RemoveUserIdFromRequests < ActiveRecord::Migration[5.1]
  def change
    remove_column :requests, :userid, :integer
  end
end
