class AddChecklistIdToRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :requests, :checklist_id, :integer, default: 0
  end
end
