# frozen_string_literal: true

module VehiclesHelper

  def show_page_a_service_row(vehicle)
    if vehicle.a_service == nil
      'No Data'
    elsif vehicle.a_service
      render 'needs_service_show_badge', mileage: vehicle.near_a_service_mileage
    else
      render 'near_service_mileage_badge', mileage: vehicle.near_a_service_mileage
    end
  end
  
  def last_a_service_badge(vehicle)
    unless @vehicle.requests.where(a_service: true).empty?
      link_to "(#{@vehicle.requests.where(a_service: true).last.completed_date.strftime('%D')}) | View", request_path(@vehicle.requests.where(program_id: @set_a_service.id).last), class: "badge badge-danger"
    else
      'None'
    end
  end

  def show_page_shock_service_row(vehicle)
    if vehicle.shock_service == nil
      'No Data'
    elsif vehicle.shock_service
      render 'needs_service_show_badge', mileage: vehicle.near_shock_service_mileage
    else
      render 'near_service_mileage_badge', mileage: vehicle.near_shock_service_mileage
    end
  end
  
  def last_shock_service_badge(vehicle)
    unless @vehicle.requests.where(shock_service: true).empty?
      link_to "(#{@vehicle.requests.where(program_id: @set_shock_service.id).last.completed_date.strftime('%D')}) | View", request_path(@vehicle.requests.where(program_id: @set_shock_service.id).last), class: "badge badge-danger"
    else
      'None'
    end
  end

  def show_page_air_filter_service_row(vehicle)
    if vehicle.air_filter_service == nil
      'No Data'
    elsif vehicle.air_filter_service
      render 'needs_service_show_badge', mileage: vehicle.near_air_filter_service_mileage
    else
      render 'near_service_mileage_badge', mileage: vehicle.near_air_filter_service_mileage
    end
  end
  
  def last_air_filter_service_badge(vehicle)
    unless @vehicle.requests.where(air_filter_service: true).empty?
      link_to "(#{@vehicle.requests.where(air_filter_service: true).last.completed_date.strftime('%D')}) | View", request_path(@vehicle.requests.where(program_id: @set_air_filter_service.id).last), class: "badge badge-danger"
    else
      'None'
    end
  end
  
  def show_page_tour_car_prep_row(vehicle)
    if vehicle.tour_car_prep == nil
      'No Data'
    elsif vehicle.tour_car_prep
      render 'needs_service_show_badge', mileage: vehicle.near_tour_car_prep_mileage
    else
      render 'near_service_mileage_badge', mileage: vehicle.near_tour_car_prep_mileage
    end
  end
  
  def last_tour_car_prep_badge(vehicle)
    unless @vehicle.requests.where(tour_car_prep: true).empty?
      link_to "(#{@vehicle.requests.where(tour_car_prep: true).last.completed_date.strftime('%v')}) | View", request_path(@vehicle.requests.where(program_id: @set_tour_car_prep.id).last), class: "badge badge-danger"
    else
      'None'
    end
  end
  
  def show_page_repairs_row(vehicle)
    if vehicle.repair_needed == nil
      'No Data'
    elsif vehicle.repair_needed
      render 'wrench_badge', data: 'Repairs In Progress'
    else
      'No Repairs In Progress'
    end
  end

  def show_page_defects_row(vehicle)
    if vehicle.defect == nil
      'No Data'
    elsif vehicle.defect
      render 'wrench_badge', data: 'Defects Reported'
    else
      'No Defects Reported'
    end
  end

  def check_for_checklists(event, vehicle)
    if vehicle.checklists.exists?(:event_id => event.id)
      link_to "Event Checklist", checklist_path(@checklists.find_by(event_id: event.id)), class: "btn btn-danger"
    else
    'No Checklist Completed'
    end
  end
end
