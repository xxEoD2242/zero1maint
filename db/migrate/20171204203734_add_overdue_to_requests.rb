class AddOverdueToRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :requests, :overdue, :boolean
  end
end
