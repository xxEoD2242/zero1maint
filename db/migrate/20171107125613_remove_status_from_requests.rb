class RemoveStatusFromRequests < ActiveRecord::Migration[5.1]
  def change
    remove_column :requests, :status, :string
  end
end
