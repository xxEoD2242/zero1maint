# frozen_string_literal: true

module RequestsHelper
  def date_title(request)
    unless request.completed?
      "Estimated Completion date:"
    else
      'Completed Date:'
    end
  end
  
  def date_badge(request)
    unless request.completed?
      request.completion_date.strftime("%v")
    else
      request.completed_date.strftime('%v')
    end
  end
  
  def badge_color(request)
    unless request.completed?
      'badge-danger'
    else
      'badge-success'
    end
  end
  
  def date_column(request)
    unless request.completed?
      'col-md-4'
    else
      'col-md-3'
    end
  end
  
  def empty_date_column(request)
    unless request.completed?
      'col-md-6'
    else
      'col-md-7'
    end
  end
  
  def table_date(request)
    unless request.completed?
      'Not Completed'
    else
      request.completed_date.strftime('%v')
    end
  end
end
