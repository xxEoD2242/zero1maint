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

  def a_service_badge(vehicle)
    if vehicle.a_service
      render 'service_badge', service: 'A-Service'
    end
  end

  def shock_service_badge(vehicle)
    if vehicle.shock_service
      render 'service_badge', service: 'Shock Service'
    end
  end

  def air_filter_service_badge(vehicle)
    if vehicle.air_filter_service
      render 'service_badge', service: 'Air Filter Service'
    end
  end
  
  def tour_car_prep_badge(vehicle)
    if vehicle.tour_car_prep
      render 'service_badge', service: 'Tour Car Prep'
    end
  end
  
  def repairs_badge(vehicle)
    if vehicle.repair_needed
      render 'service_badge', service: 'Repairs In Progress'
    end
  end
  
  def defects_badge(vehicle)
    if vehicle.defect
      render 'service_badge', service: 'Defects Reported'
    end
  end
  
  def near_a_service_badge(vehicle)
    if vehicle.near_a_service
      render 'near_service_badge', vehicle_mileage: vehicle.near_a_service_mileage, service: 'A-Service'
    end
  end
  
  def near_shock_service_badge(vehicle)
    if vehicle.near_shock_service
      render 'near_service_badge', vehicle_mileage: vehicle.near_shock_service_mileage, service: 'Shock Service'
    end
  end

  def near_air_filter_service_badge(vehicle)
    if vehicle.near_air_filter_service
      render 'near_service_badge', vehicle_mileage: vehicle.near_air_filter_service_mileage, service: 'Air Filter Service'
    end
  end
  
  def near_tour_car_prep_badge(vehicle)
    if vehicle.near_tour_car_prep
      render 'near_service_badge', vehicle_mileage: vehicle.near_tour_car_prep_mileage, service: 'Tour Car Prep'
    end
  end
  
  def vehicle_status_badge_color(vehicle)
    if vehicle.is_in_service?
      'badge-success'
    else
      'badge-danger'
    end
  end

  def near_service_badge_color(mileage)
    if mileage < 0
      'badge-danger'
    else
      'badge-warning'
    end
  end
end
