class AddManuallyReportedToDefects < ActiveRecord::Migration[5.1]
  def change
    add_column :defects, :manually_reported, :boolean
    remove_column :defects, :checklist_id, :integer
  end
end
