# frozen_string_literal: true

module VehiclesHelper
  def fixed_defect_badge(defect)
    if defect.fixed
      'badge-success'
    else
      'badge-danger'
    end
  end

  def fixed_defect_word(defect)
    if defect.fixed
      'Fixed'
    else
      'Not Fixed'
    end
  end

  def defect_date(defect)
    if defect.fixed
      defect.date_fixed.strftime('%v')
    else
      'Not Fixed'
    end
  end
  
  def work_order_link(defect)
    if defect.requests.exists?
      link_to "Work Order", request_path(defect.requests.last.id), class: 'btn btn-danger btn-sm'
    elsif defect.checklist
      link_to 'Create W/O', create_defect_work_order_defects_path(checklist_id: defect.checklist.id, vehicle_id: defect.vehicle.id, defect_id: defect.id), class: 'btn btn-secondary btn-sm'
    else
      'No Checklist'
    end
  end
  
  def last_event(defect)
    if defect.last_event_reported
      link_to "#{defect.last_event_reported}", event_path(defect.last_event_reported), class: "badge badge-danger"
    else
      'None'
    end
  end
  
  def category_words(defect)
    if defect.category
      defect.category.tr('_', ' ').capitalize
    else
      'No Category Given'
    end
  end
end
