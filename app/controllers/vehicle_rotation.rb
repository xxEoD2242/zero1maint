# frozen_string_literal: true

module Vehicle_Rotation
  def vehicle_rotation
    current_events = Event.where('date >= ? AND date <= ?', (Date.current), (Date.current + 7.days))
    @scheduled_events = current_events.are_scheduled?
    @vehicles_assigned = current_events.are_vehicles_assigned?
    event_mileage = 0
    new_event_mileage = 0
    @total_miles_added = 0
    @total_miles = 0

    unless @scheduled_events.empty?
      @scheduled_events.each do |event|
        event_mileage += event.est_mileage
      end
      @total_miles = event_mileage.round(2)
    end

    @vehicles = Vehicle.where(veh_category: "RZR")

    @vehicles.update(use_a: true, use_b: false, dont_use_near_a_service: false,
                     dont_use_near_shock_service: false, dont_use_near_air_filter_service: false, est_mileage: 0)
    
    @vehicles.each do |vehicle|
      vehicle.update(est_mileage: (vehicle.mileage + @total_miles))
    end
    
    unless @vehicles_assigned.empty?
      @vehicles_assigned.each do |event|
        @total_miles_added += event.est_mileage
        event.vehicles.each do |vehicle|
          vehicle.update(est_mileage: (vehicle.est_mileage + event.est_mileage))
        end
      end
    end

    vehicle_rotation_determination @vehicles

    @q = Vehicle.all.ransack(params[:q])
    @vehicle_results = @q.result

    to_pdf "Vehicle Rotation for #{Time.now.strftime('%D')}"
  end

  # Create a filed in the Vehicles table that would track if the vehicle has been used within the last week and then update that vehicle

  def vehicle_rotation_determination(vehicles)
    vehicles.all.each do |vehicle|

        vehicle.update(dont_use_near_a_service_mileage: (vehicle.a_service_interval - (vehicle.est_mileage - vehicle.last_a_service)))
        x = vehicle.dont_use_near_a_service_mileage
        if x <= 0
          vehicle.update(use_b: true, use_a: false, dont_use_a_service: true)
        elsif x <= Program.a_service.threshold_numb
          vehicle.update(dont_use_near_a_service: true)
        else
          vehicle.update(dont_use_a_service: false, dont_use_near_a_service: false)
        end

        vehicle.update(dont_use_near_shock_service_mileage: (vehicle.shock_service_interval - (vehicle.est_mileage - vehicle.last_shock_service)))
        y = vehicle.dont_use_near_shock_service_mileage
        if y < 0
          vehicle.update(use_b: true, use_a: false, dont_use_shock_service: true)
        elsif y <= Program.shock_service.threshold_numb
          vehicle.update(dont_use_near_shock_service: true)
        else
          vehicle.update(dont_use_shock_service: false)
        end

        vehicle.update(dont_use_near_air_filter_service_mileage: (vehicle.air_filter_service_interval - (vehicle.est_mileage - vehicle.last_air_filter_service)))
        z = vehicle.dont_use_near_air_filter_service_mileage
        if z < 0
          vehicle.update(use_b: true, use_a: false, dont_use_air_filter_service: true)
        elsif z <= Program.air_filter_service.threshold_numb
          vehicle.update(dont_use_near_air_filter_service: true)
        else
          vehicle.update(dont_use_air_filter_service: false, dont_use_near_air_filter_service: false)
        end
        
        if vehicle.tour_car?
          vehicle.update(dont_use_near_tour_car_prep: false)
          
          vehicle.update(dont_use_near_tour_car_prep_mileage: (vehicle.tour_car_prep_interval - (vehicle.est_mileage - vehicle.last_air_filter_service)))
          a = vehicle.dont_use_near_tour_car_prep_mileage
          if a < 0
            vehicle.update(use_b: true, use_a: false, dont_use_tour_car_prep: true)
          elsif a <= Program.tour_car_prep.threshold_numb
            vehicle.update(dont_use_near_tour_car_prep: true)
          else
            vehicle.update(dont_use_tour_car_prep: false, dont_use_near_tour_car_prep: false)
          end
        end

      unless vehicle.times_used.nil?
        if vehicle.use_a && vehicle.times_used >= 5 && vehicle.high_use == false
          vehicle.update(use_a: false, use_b: true)
        elsif vehicle.use_b && vehicle.times_used >= 10 && vehicle.high_use == false
          vehicle.update(use_a: false, use_b: false)
        end
      end

      vehicle.update(use_a: false, use_b: true) if vehicle.needs_service

      vehicle.update(use_a: false, use_b: true) if vehicle.near_service

      if vehicle.vehicle_status == 'Out-of-Service'
        vehicle.update(use_a: false, use_b: false)
      end
    end
  end

  def vehicle_use_count
    @eve = Event.where('date >= ?', Time.now - 1.month)
    @events = @eve.where('date <= ?', Time.now)
    Vehicle.all.update(times_used: 0)
    @events.each do |event|
      if event.vehicles.exists?
        event.vehicles.update(times_used: 0)
      end
      next unless event.vehicles.exists?
      event.vehicles.each do |vehicle|
        vehicle.update(times_used: (vehicle.times_used + 1))
      end
    end
  end

  def mileage_calculation
    Vehicle.in_service?.each do |vehicle|
      a_service_check vehicle
      shock_service_check vehicle 
      air_filter_service_check vehicle
      if vehicle.tour_car?
        tour_car_prep_check vehicle
      end
      need_service_check vehicle
      near_service_check vehicle
      defects_check vehicle
    end
  end

  def need_service_check(vehicle)
    if !vehicle.air_filter_service && !vehicle.shock_service && !vehicle.a_service && !vehicle.tour_car_prep
      vehicle.update(needs_service: false)
    end 
  end

  def near_service_check(vehicle)
    if !vehicle.near_air_filter_service && !vehicle.near_shock_service && !vehicle.near_a_service && !vehicle.near_tour_car_prep
      vehicle.update(near_service: false)
    end 
  end

  def air_filter_service_check(vehicle)
    vehicle.update(near_air_filter_service_mileage: (vehicle.air_filter_service_interval - (vehicle.mileage - vehicle.last_air_filter_service)))
    if vehicle.near_air_filter_service_mileage < 0
      vehicle.update(needs_service: true, air_filter_service: true, near_air_filter_service: false)
    elsif vehicle.near_air_filter_service_mileage <= @set_air_filter_service.threshold_numb
      vehicle.update(near_air_filter_service: true, near_service: true)
    else
      vehicle.update(air_filter_service: false, near_air_filter_service: false)
    end
  end

  def shock_service_check(vehicle)
    vehicle.update(near_shock_service_mileage: (vehicle.shock_service_interval - (vehicle.mileage - vehicle.last_shock_service)))
    if vehicle.near_shock_service_mileage < 0
      vehicle.update(needs_service: true, shock_service: true, near_shock_service: false)
    elsif vehicle.near_shock_service_mileage <= @set_shock_service.threshold_numb
      vehicle.update(near_shock_service: true, near_service: true)
    else
      vehicle.update(shock_service: false, near_shock_service: false)
    end
  end

  def a_service_check(vehicle)
    vehicle.update(near_a_service_mileage: (vehicle.a_service_interval - (vehicle.mileage - vehicle.last_a_service)))
    if vehicle.near_a_service_mileage < 0
      vehicle.update(needs_service: true, a_service: true, near_a_service: false)
    elsif vehicle.near_a_service_mileage <= @set_a_service.threshold_numb
      vehicle.update(near_a_service: true, near_service: true)
    else
      vehicle.update(a_service: false, near_a_service: false)
    end
  end
  
  def tour_car_prep_check(vehicle)
    if vehicle.veh_category == 'Tour Car'
      vehicle.update(near_tour_car_prep_mileage: (vehicle.tour_car_prep_interval - (vehicle.mileage - vehicle.last_tour_car_prep_mileage)))
      if vehicle.near_tour_car_prep_mileage < 0
        vehicle.update(needs_service: true, tour_car_prep: true, near_tour_car_prep: false)
      elsif vehicle.near_tour_car_prep_mileage < 100
        vehicle.update(near_service: true, near_tour_car_prep: true)
      else
        vehicle.update(tour_car_prep: false, near_tour_car_prep: false)
      end
    end
  end
end
