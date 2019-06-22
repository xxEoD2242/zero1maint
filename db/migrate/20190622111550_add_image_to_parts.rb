class AddImageToParts < ActiveRecord::Migration[5.1]
  def change
    add_column :parts, :image, :string
  end
end
