# frozen_string_literal: true

module DefectsHelper
  def category_words(defect)
    if defect.category
      defect.category.tr('_', ' ').capitalize
    else
      'No Category Given'
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
end