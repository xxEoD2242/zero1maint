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
end
