class AddOldDefectIdsToChecklists < ActiveRecord::Migration[5.1]
  def change
     add_column :checklists, :defect_ids_old, :string, array: true, default: '{}'
  end
end
