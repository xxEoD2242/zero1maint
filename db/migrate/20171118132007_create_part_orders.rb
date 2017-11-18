class CreatePartOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :part_orders do |t|
      t.integer :invoice_numb
      t.integer :part_id
      t.integer :quantity
      t.string :brand
      t.text :description
      t.string :category
      t.integer :user_id
      t.string :vendor

      t.timestamps
    end
  end
end
