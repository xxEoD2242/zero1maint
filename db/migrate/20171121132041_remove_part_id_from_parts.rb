class RemovePartIdFromParts < ActiveRecord::Migration[5.1]
  def change
    remove_column :parts, :part_id, :integer
  end
end
