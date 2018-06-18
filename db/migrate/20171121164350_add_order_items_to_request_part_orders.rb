# frozen_string_literal: true

class AddOrderItemsToRequestPartOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :request_part_orders, :order_items, :text
  end
end
