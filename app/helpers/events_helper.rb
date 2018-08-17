# frozen_string_literal: true

module EventsHelper
  def vehicle_table_services(vehicle)
    if vehicle.use_near_service

    end
  end

  def auto_select_vehicles(_event)
    if @event.customers && @event.customers > 0
      link_to 'Auto Select Vehicles', auto_select_vehicles_events_path(id: @event.id), class: 'btn btn-danger'
    end
  end

  def checklist_button_color(checklists, vehicle)
    if checklists.find_by(vehicle_id: vehicle.id).has_defects?
      link_to 'Checklist', checklist_path(checklists.find_by(vehicle_id: vehicle.id).id), class: 'btn btn-warning ml-1'
    else
      link_to 'Checklist', checklist_path(checklists.find_by(vehicle_id: vehicle.id).id), class: 'btn btn-danger ml-1'
    end
  end

  def calendar_symbol(event)
    if event.vehicles.exists? && event.checklists_completed
      'fa-check'
    elsif !event.checklists_completed && event.vehicles.exists?
      'fa-exclamation-triangle'
    else
      'fa-car'
    end
  end

  def calendar_event_word(event)
    if event.checklists.exists?
      if event.checklists_completed
        'Checklists Completed'
      else
        'Checklists Not Completed'
      end
    else
      'No Vehicles Added!'
    end
  end

  def event_link_color(event)
    if event.is_completed?
      'badge-success'
    else
      'badge-danger'
    end
  end
  
  def vehicle_rotation_a_service_badge(vehicle)
    render 'service_badge', service: 'A-Service' if vehicle.dont_use_a_service
  end
  
  def vehicle_rotation_shock_service_badge(vehicle)
    render 'service_badge', service: 'Shock Service' if vehicle.dont_use_shock_service
  end

  def vehicle_rotation_air_filter_service_badge(vehicle)
    render 'service_badge', service: 'Air Filter Service' if vehicle.dont_use_air_filter_service
  end
  
  def vehicle_rotation_tour_car_prep_badge(vehicle)
    render 'service_badge', service: 'Tour Car Prep' if vehicle.dont_use_tour_car_prep
  end
  
  def vehicle_rotation_near_a_service_badge(vehicle)
    if vehicle.dont_use_near_a_service
      render 'near_service_badge', vehicle_mileage: vehicle.dont_use_near_a_service_mileage, service: 'A-Service'
    end
  end
  
  def vehicle_rotation_near_shock_service_badge(vehicle)
    if vehicle.dont_use_near_shock_service
      render 'near_service_badge', vehicle_mileage: vehicle.dont_use_near_shock_service_mileage, service: 'Shock Service'
    end
  end

  def vehicle_rotation_near_air_filter_service_badge(vehicle)
    if vehicle.dont_use_near_air_filter_service
      render 'near_service_badge', vehicle_mileage: vehicle.dont_use_near_air_filter_service_mileage, service: 'Air Filter Service'
    end
  end
  
  def vehicle_rotation_near_tour_car_prep_badge(vehicle)
    if vehicle.dont_use_near_tour_car_prep
      render 'near_service_badge', vehicle_mileage: vehicle.dont_use_near_tour_car_prep_mileage, service: 'Tour Car Prep'
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

  def event_status_badge(event)
    if event.is_completed?
      'badge-success'
    else
      'badge-danger'
    end
  end
end
