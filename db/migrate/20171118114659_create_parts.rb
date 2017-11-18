class CreateParts < ActiveRecord::Migration[5.1]
  def change
    create_table :parts do |t|
      t.integer :part_id
      t.string :description
      t.string :brand
      t.string :category
      t.decimal :cost
      t.integer :quantity

      t.timestamps
    end
  end
end
