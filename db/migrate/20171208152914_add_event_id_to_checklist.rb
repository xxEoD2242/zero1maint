class AddEventIdToChecklist < ActiveRecord::Migration[5.1]
  def change
    add_column :checklists, :event_id, :integer
  end
end
