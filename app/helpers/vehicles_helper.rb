# frozen_string_literal: true

module VehiclesHelper
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
end
