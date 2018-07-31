class AddDefectToChecklist < ActiveRecord::Migration[5.1]
  def change
    add_column :checklists, :defect, :boolean
  end
end
