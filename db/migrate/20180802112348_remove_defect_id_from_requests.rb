class RemoveDefectIdFromRequests < ActiveRecord::Migration[5.1]
  def change
    remove_column :requests, :defect_id, :integer
  end
end
