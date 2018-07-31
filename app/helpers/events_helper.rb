# frozen_string_literal: true

module EventsHelper
  def vehicle_table_services(vehicle)
    if vehicle.use_near_service
      
    end
  end
  
  def auto_select_vehicles(event)
    if @event.customers && @event.customers > 0
    link_to "Auto Select Vehicles", auto_select_vehicles_events_path(id: @event.id), class: "btn btn-danger"
    end
  end
  def checklist_button_color(checklists, vehicle)
    if checklists.find_by(vehicle_id: vehicle.id).has_defects?
      link_to "Checklist", checklist_path(checklists.find_by(vehicle_id: vehicle.id).id), class: "btn btn-warning ml-1"
    else
      link_to "Checklist", checklist_path(checklists.find_by(vehicle_id: vehicle.id).id), class: "btn btn-danger ml-1"
    end
  end
end
