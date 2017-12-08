class AddDateToChecklist < ActiveRecord::Migration[5.1]
  def change
    add_column :checklists, :date, :date
  end
end
