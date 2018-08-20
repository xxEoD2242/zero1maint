# frozen_string_literal: true

module DefectsHelper
  
  def repairs_row(defect)
    if defect.fixed?
      render 'show_repairs_column', defect: @defect
    end
  end
end
