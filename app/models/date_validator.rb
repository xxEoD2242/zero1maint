class DateValidator < ActiveModel::Validator
  
  def validate(record)
    if record.completion_date < Time.now
      record.errors[:base] << "The Completion Date cannot be in the past!"
    end
  end
end