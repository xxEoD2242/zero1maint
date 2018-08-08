# frozen_string_literal: true

module ReportsHelper
  def work_order_completed_date_badge(request)
    if request.completed?
      'badge-success'
    else
      'badge-danger'
    end
  end

  def work_order_completed_date(request)
    if request.completed?
      request.completed_date.strftime('%v')
    else
      'Not Completed'
    end
  end
  
  def work_order_completion_date(request)
    if request.completed?
      request.completion_date.strftime('%v')
    else
      'Not Completed'
    end
  end
  
  def checklist_button(vehicle, event)
    unless vehicle.checklists.empty? 
      if vehicle.checklists.where(event_id: event.id).exists? 
        link_to "Show Checklist", checklist_path( vehicle.checklists.find_by(event_id: event.id).id), class: "btn btn-danger btn-sm"
      else
        render 'not_completed_checklists'
      end
    else
      render 'not_created_checklists'
    end
  end

  def deadlined_field(vehicle, event)
    unless vehicle.checklists.empty? 
      if vehicle.checklists.where(event_id: event.id).exists?
        if vehicle.checklists.find_by(event_id: event.id).deadline
          render 'deadlined_badge_checklists'
        else
          render 'in_service_badge_checklists'
        end
      else
        render 'not_completed_checklists'
      end
    else
      render 'not_created_checklists'
    end
  end
  
  def completed_date_checklists(vehicle, event)
    unless vehicle.checklists.empty? 
      if vehicle.checklists.where(event_id: event.id).exists?
        render 'completed_date_badge', vehicle: vehicle, event: event
      else
        render 'not_completed_checklists'
      end
    else
      render 'not_created_checklists'
    end
  end
  
  def completed_checklists(vehicle, event)
    unless vehicle.checklists.empty?
      if vehicle.checklists.where(event_id: event.id).exists?
        render 'completed_checklists_badge'
      else 
        render 'not_completed_checklists'
      end
    else
      render 'not_created_checklists'
    end
  end
end
