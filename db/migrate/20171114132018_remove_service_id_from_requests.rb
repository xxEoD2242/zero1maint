class RemoveServiceIdFromRequests < ActiveRecord::Migration[5.1]
  def change
    remove_column :requests, :service_id, :integer
  end
end
