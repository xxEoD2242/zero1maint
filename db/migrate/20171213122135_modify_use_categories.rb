class ModifyUseCategories < ActiveRecord::Migration[5.1]
  def change
    rename_column :vehicles, :use, :use_a
    add_column :vehicles, :use_b, :boolean
  end
end
