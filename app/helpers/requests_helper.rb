# frozen_string_literal: true

module RequestsHelper
  def date_title(request)
    if request.completed?
      'Completed Date:'
    else
      'Estimated Completion date:'
    end
  end

  def date_badge(request)
    if request.completed?
      request.completed_date.strftime('%v')
    else
      request.completion_date.strftime('%v')
    end
  end

  def badge_color(request)
    if request.completed?
      'badge-success'
    else
      'badge-danger'
    end
  end

  def date_column(request)
    if request.completed?
      'col-md-3'
    else
      'col-md-4'
    end
  end

  def empty_date_column(request)
    if request.completed?
      'col-md-7'
    else
      'col-md-6'
    end
  end

  def table_date(request)
    if request.completed?
      request.completed_date.strftime('%v')
    else
      'Not Completed'
    end
  end
  
  def last_event(defect)
    if defect.last_event_reported
      link_to "Event #{defect.last_event_reported}", event_path(defect.last_event_reported), class: "badge badge-danger"
    end
  end
end
