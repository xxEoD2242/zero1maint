class AddTimesReportedToDefects < ActiveRecord::Migration[5.1]
  def change
    add_column :defects, :times_reported, :integer, default: 0
    add_column :defects, :last_event_reported, :integer
  end
end
