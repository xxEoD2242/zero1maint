class AddOrderTotalToRequestPartOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :request_part_orders, :order_total, :float
  end
end
