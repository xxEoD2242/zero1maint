desc 'Update times used for each vehicle for the month'
task update_times_used_month: :environment do
  if Date.today.monday?
    Vehicle.all.each do |vehicle|
      Event.where("date > ?", Date.today - 1.month).each do |event|
        if event.vehicles.include?(vehicle)
          vehicle.update(times_used: vehicle.times_used + 1)
        end
      end
    end
  end
end

desc 'Update times used for each vehicle for the year'
task update_times_used_year: :environment do
  if Date.today.monday?
    Vehicle.all.each do |vehicle|
      Event.where("date > ?", Date.today - 1.year).each do |event|
        if event.vehicles.include?(vehicle)
          vehicle.update(times_used_year: vehicle.times_used_year + 1)
        end
      end
    end
  end
end
