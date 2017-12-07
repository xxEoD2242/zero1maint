class AddPartItemTotalToPartItem < ActiveRecord::Migration[5.1]
  def change
    add_column :part_items, :part_item_total, :float
  end
end
