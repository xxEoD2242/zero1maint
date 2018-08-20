class AddRepairMethodToDefects < ActiveRecord::Migration[5.1]
  def change
    add_column :defects, :repair, :text, default: ''
    add_column :defects, :notes, :text, default: ''
    add_column :defects, :mechanic, :string, default: ''
    add_column :requests, :mechanic, :string, default: ''
    add_column :requests, :times_completed, :integer, default: 0
    add_column :defects, :times_completed, :integer, default: 0
    add_column :defects, :user_id, :integer
    add_column :requests, :notes, :text, default: ''
    add_column :requests, :mechanic_id, :integer
    remove_column :requests, :poc, :string
  end
end
