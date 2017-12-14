class AddCustomersToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :customers, :integer
    add_column :events, :shares, :integer
  end
end
