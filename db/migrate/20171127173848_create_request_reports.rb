class CreateRequestReports < ActiveRecord::Migration[5.1]
  def change
    create_table :request_reports do |t|
      t.integer :request_id
      t.integer :report_id

      t.timestamps
    end
  end
end
