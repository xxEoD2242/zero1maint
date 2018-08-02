class CreateDefectRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :defect_requests do |t|
      t.integer :defect_id
      t.integer :request_id

      t.timestamps
    end
  end
end
