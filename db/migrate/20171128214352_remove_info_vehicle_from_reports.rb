# frozen_string_literal: true

class RemoveInfoVehicleFromReports < ActiveRecord::Migration[5.1]
  def change
    remove_column :reports, :info_vehicle, :text
  end
end
