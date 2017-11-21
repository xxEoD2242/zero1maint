class CreateRequestPartOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :request_part_orders do |t|
      t.integer :request_id
      t.integer :user_id
      t.text :part_items

      t.timestamps
    end
  end
end
