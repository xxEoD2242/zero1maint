# frozen_string_literal: true

module ApplicationHelper
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
  
  def defect_checklist(defect)
    if !defect.checklists.empty?
      link_to "Checklist #{defect.checklists.last.id}", checklist_path(defect.checklists.last.id), class: 'btn btn-danger btn-sm'
    else
      'None'
    end
  end
  
  def work_order_link(defect)
    if defect.requests.exists?
      link_to "Work Order", request_path(defect.requests.last.id), class: 'btn btn-danger btn-sm'
    elsif defect.checklists.exists?
      link_to 'Create W/O', create_defect_work_order_defects_path(checklist_id: defect.checklists.last.id, vehicle_id: defect.vehicle.id, defect_id: defect.id), class: 'btn btn-secondary btn-sm'
    elsif !defect.checklists.exists?
      link_to link_to 'Create W/O', create_manual_defect_work_order_defects_path(vehicle_id: defect.vehicle.id, defect_id: defect.id), class: 'btn btn-secondary btn-sm'
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

  def vehicle_services_badges(vehicle)
    return 'A-Service' if vehicle.a_service
    return 'Shock Service' if vehicle.shock_service
    return 'Air Filter Service' if vehicle.air_filter_service
    return 'Repairs In Progress' if vehicle.repair_needed
    return 'Defects Reported' if vehicle.defect
  end
  
  def near_service_badge_color(mileage)
    if mileage < 0
      'badge-danger'
    else
      'badge-warning'
    end
  end
end
