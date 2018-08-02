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
    else
      link_to 'Create W/O', create_defect_work_order_defects_path(checklist_id: defect.checklist.id, vehicle_id: defect.vehicle.id, defect_id: defect.id), class: 'btn btn-danger btn-sm'
    end
  end
end
