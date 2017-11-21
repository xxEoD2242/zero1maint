class RemovePartItemsFromRequestPartOrders < ActiveRecord::Migration[5.1]
  def change
    remove_column :request_part_orders, :part_items, :text
  end
end
