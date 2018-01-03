class CreateRotationMetrics < ActiveRecord::Migration[5.1]
  def change
    create_table :rotation_metrics do |t|
      t.integer :a_times_used
      t.integer :b_times_used

      t.timestamps
    end
  end
end
