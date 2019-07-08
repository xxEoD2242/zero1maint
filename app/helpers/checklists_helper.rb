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
  
  def type_word(vehicle, event)
    if vehicle.checklists.empty?
      'Not Created'
    else
      if vehicle.checklists.where(event_id: event.id, checklist_type: 'Pre-Event').exists?
        'Pre-Event'
      elsif vehicle.checklists.where(event_id: event.id, checklist_type: 'Post-Event').exists?
        'Post-Event'
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
end
