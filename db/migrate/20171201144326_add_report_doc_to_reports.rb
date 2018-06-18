# frozen_string_literal: true

class AddReportDocToReports < ActiveRecord::Migration[5.1]
  def change
    add_column :reports, :report_doc, :string
  end
end
