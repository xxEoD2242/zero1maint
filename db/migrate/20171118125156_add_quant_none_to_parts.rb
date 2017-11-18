class AddQuantNoneToParts < ActiveRecord::Migration[5.1]
  def change
    add_column :parts, :quant_none, :boolean
  end
end
