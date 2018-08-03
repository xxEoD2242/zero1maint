class CreateChecklistDefects < ActiveRecord::Migration[5.1]
  def change
    create_table :checklist_defects do |t|
      t.integer :checklist_id
      t.integer :defect_id

      t.timestamps
    end
  end
end
