class AddCategoryToDefects < ActiveRecord::Migration[5.1]
  def change
    add_column :defects, :category, :string, default: ""
  end
end
