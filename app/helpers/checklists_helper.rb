# frozen_string_literal: true

module ChecklistsHelper
  def status_symbol(vehicle, event)
    if vehicle.checklists.empty?
      'fa-thumbs-down'
    else
      if vehicle.checklists.where(event_id: event.id).exists?
        'fa-check'
      else
        'fa-thumbs-down'
      end
    end
  end

  def status_word(vehicle, event)
    if vehicle.checklists.empty?
      'Not Created'
    else
      if vehicle.checklists.where(event_id: event.id).exists?
        'Completed'
      else
        'Not Completed'
      end
    end
  end

  def status_word_color(vehicle, event)
    if vehicle.checklists.empty?
      'text-danger'
    else
      if vehicle.checklists.where(event_id: event.id).exists?
        'text-success'
      else
        'text-warning'
      end
    end
  end

  def status_date_word(vehicle, event)
    if vehicle.checklists.empty?
      'Not Created'
    else
      if vehicle.checklists.where(event_id: event.id).exists?
        vehicle.checklists.find_by(event_id: event.id).date.strftime('%D')
      else
        'Not Completed'
      end
    end
  end

  def deadline_word(vehicle, event)
    if vehicle.checklists.empty?
      'Not Created'
    else
      if vehicle.checklists.where(event_id: event.id).exists?
        if vehicle.checklists.find_by(event_id: event.id).deadline
          'Deadlined'
        else
          'Not Deadlined'
        end
      else
        'Not Completed'
      end
    end
  end

  def deadline_badge_color(vehicle, event)
    unless vehicle.checklists.empty?
      if vehicle.checklists.where(event_id: event.id).exists?
        if vehicle.checklists.find_by(event_id: event.id).deadline
          'badge-danger'
        else
          'badge-success'
        end
      else
        'badge-warning'
      end
    end
  end

  def deadline_symbol(vehicle, event)
    unless vehicle.checklists.empty?
      if vehicle.checklists.where(event_id: event.id).exists?
        if vehicle.checklists.find_by(event_id: event.id).deadline
          'fa-exclamation-triangle'
        else
          'fa-check'
        end
      else
        'fa-thumbs-down'
      end
    end
  end

  def checklist_link(vehicle, event)
    if vehicle.checklists.empty?
      'Not Created'
    else
      if vehicle.checklists.where(event_id: event.id).exists?
        link_to 'Show Checklist', checklist_path(vehicle.checklists.find_by(event_id: event.id).id), class: 'btn btn-danger btn-sm'
      else
        'Not Completed'
      end
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
