class AddDeadlineToChecklist < ActiveRecord::Migration[5.1]
  def change
    add_column :checklists, :deadline, :boolean
  end
end
