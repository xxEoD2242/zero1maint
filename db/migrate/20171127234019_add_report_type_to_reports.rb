class AddReportTypeToReports < ActiveRecord::Migration[5.1]
  def change
    add_column :reports, :report_type, :string
  end
end
