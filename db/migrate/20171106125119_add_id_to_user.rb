class AddIdToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :emplyid, :integer
  end
end
