# frozen_string_literal: true

module DefectsHelper
  def category_words(defect)
    if defect.category
      defect.category.tr('_', ' ').capitalize
    else
      'No Category Given'
    end
  end
end
