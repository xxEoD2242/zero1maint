class AddDuplicateCopiesToDefects < ActiveRecord::Migration[5.1]
  def change
    add_column :checklists, :wash_old, :string
    add_column :checklists, :suspension_old, :string
    add_column :checklists, :drive_train_old, :string
    add_column :checklists, :body_old, :string
    add_column :checklists, :engine_old, :string
    add_column :checklists, :brakes_old, :string
    add_column :checklists, :safety_equipment_old, :string
    add_column :checklists, :chassis_old, :string
    add_column :checklists, :electrical_old, :string
    add_column :checklists, :cooling_system_old, :string
    add_column :checklists, :tires_old, :string
    add_column :checklists, :radio_old, :string
    add_column :checklists, :exhaust_old, :string
    add_column :checklists, :steering_old, :string
    rename_column :checklists, :brake, :brakes
  end
end
