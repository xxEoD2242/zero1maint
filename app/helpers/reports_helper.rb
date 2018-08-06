# frozen_string_literal: true

module ReportsHelper
  def work_order_completed_date_badge(request)
    if request.completed_date
      'badge-success'
    else
      'badge-danger'
    end
  end

  def work_order_completed_date(request)
    if request.completed_date
      request.completed_date.strftime('%v')
    else
      'Not Completed'
    end
  end
  
  def work_order_completion_date(request)
    if request.completion_date
      request.completion_date.strftime('%v')
    else
      'Not Completed'
    end
  end
end
