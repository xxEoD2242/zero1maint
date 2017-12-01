class RemoveRecordFromReports < ActiveRecord::Migration[5.1]
  def change
    remove_column :reports, :record, :string
  end
end
