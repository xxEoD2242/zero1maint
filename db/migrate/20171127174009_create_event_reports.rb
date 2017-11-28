class CreateEventReports < ActiveRecord::Migration[5.1]
  def change
    create_table :event_reports do |t|
      t.integer :event_id
      t.integer :report_id

      t.timestamps
    end
  end
end
