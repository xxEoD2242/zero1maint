class AddQuantLowToParts < ActiveRecord::Migration[5.1]
  def change
    add_column :parts, :quant_low, :boolean
  end
end
