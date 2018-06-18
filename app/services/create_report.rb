# frozen_string_literal: true

class CreateReport
  def initialize(user, report)
    @users = user
    @description = report.description
    @type = report.report_type
  end
end
