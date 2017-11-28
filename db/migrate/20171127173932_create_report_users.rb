class CreateReportUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :report_users do |t|
      t.integer :report_id
      t.integer :user_id

      t.timestamps
    end
  end
end
