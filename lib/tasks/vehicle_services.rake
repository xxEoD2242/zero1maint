# frozen_string_literal: true

desc 'Calculate if services needed in the morning'
task needs_service_check_morning: :environment do

  include Vehicle_Rotation

  mileage_calculation
end

desc 'Calculate if services needed at night'
task needs_service_check_night: :environment do

  include Vehicle_Rotation

  mileage_calculation
end
