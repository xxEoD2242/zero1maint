# frozen_string_literal: true

module Vehicle_Rotation
  def vehicle_rotation
    @events = Event.where('date >= ?', Time.now)
    @events_2 = @events.where('date <= ?', Time.now + 7.days)
    @scheduled_events = @events_2.all.where(status: 'Scheduled')
    event_mileage = 0
    new_event_mileage = 0
    @total_miles_added = 0
    if @scheduled_events != []
      @scheduled_events.each do |event|
        event_mileage += event.est_mileage
      end
      @total_miles = event_mileage
    end
    @vehicles_assigned = @events.all.where(status: 'Vehicles Assigned')

    @vehicles = Vehicle.all
    @vehicles.update(use_a: true, use_b: false, use_near_service: false)
    if @total_miles.nil?
      @vehicles.update(est_mileage: 0)
    else
      @vehicles.update(est_mileage: @total_miles)
    end
    if @vehicles_assigned != []
      @vehicles_assigned.each do |event|
        @total_miles_added += event.est_mileage
        event.vehicles.each do |vehicle|
          vehicle.update(est_mileage: (vehicle.est_mileage + event.est_mileage))
        end
      end
    end

    @vehicles.all.each do |vehicle|
      unless vehicle.last_a_service.nil?
        vehicle.update(near_a_service_mileage: (vehicle.a_service_interval - (vehicle.mileage - vehicle.last_a_service)))
        x = vehicle.near_a_service_mileage
        case
        when x <= 0
          vehicle.update(use_b: true, use_a: false, dont_use_a_service: true)
        when x <= @set_a_service.threshold_numb
          vehicle.update(use_near_service: true, dont_use_a_service: false)
        else
          vehicle.update(dont_use_a_service: false)
        end
      end

      unless vehicle.last_shock_service.nil?
        vehicle.update(near_shock_service_mileage: (vehicle.shock_service_interval - (vehicle.mileage - vehicle.last_shock_service)))
        y = vehicle.near_shock_service_mileage
        case 
        when y < 0
          vehicle.update(use_b: true, use_a: false, dont_use_shock_service: true)
        when y <= @set_shock_service.threshold_numb
          vehicle.update(use_near_service: true, dont_use_shock_service: false)
        else
          vehicle.update(dont_use_shock_service: false)
        end
      end

      unless vehicle.last_air_filter_service.nil?
        vehicle.update(near_air_filter_service_mileage: (vehicle.air_filter_service_interval - (vehicle.mileage - vehicle.last_air_filter_service)))
        z = vehicle.near_air_filter_service_mileage
        case
        when z < 0
          vehicle.update(use_b: true, use_a: false, dont_use_air_filter_service: true)
        when z <= @set_air_filter_service.threshold_numb
          vehicle.update(use_near_service: true, dont_use_air_filter_service: false)
        else
          vehicle.update(dont_use_air_filter_service: false)
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

    @q = Vehicle.all.ransack(params[:q])
    @vehicle_results = @q.result

    respond_to do |format|
      format.html
      format.xls
      format.pdf do
        render pdf: "Vehicle Rotation for #{Time.now.strftime('%D')}", layout: 'pdf.pdf.erb', title: "Vehicle Rotation for #{Time.now.strftime('%D')}" 
      end
    end
  end

  def vehicle_use_count
    @eve = Event.where('date >= ?', Time.now - 1.month)
    @events = @eve.where('date <= ?', Time.now)
    Vehicle.all.update(times_used: 0)
    @events.each do |event|
      next unless event.vehicles.exists?
      event.vehicles.each do |vehicle|
        vehicle.update(times_used: (vehicle.times_used + 1))
      end
    end
  end

  def mileage_calculation
    Vehicle.in_service.each do |vehicle|
      unless vehicle.last_a_service.nil?
        vehicle.update(near_a_service_mileage: (vehicle.a_service_interval - (vehicle.mileage - vehicle.last_a_service)))
        x = vehicle.near_a_service_mileage
        case 
        when x < 0
          vehicle.update(needs_service: true, a_service: true)
        when x  <= @set_a_service.threshold_numb
          vehicle.update(near_service: true)
        else
          vehicle.update(needs_service: false, a_service: false, near_service: false)
        end
      end
      unless vehicle.last_shock_service.nil?
        vehicle.update(near_shock_service_mileage: (vehicle.shock_service_interval - (vehicle.mileage - vehicle.last_shock_service)))
        y = vehicle.near_shock_service_mileage
        case 
        when y < 0
          vehicle.update(needs_service: true, shock_service: true)
        when y <= @set_shock_service.threshold_numb
          vehicle.update(near_service: true)
        else
          vehicle.update(needs_service: false, shock_service: false, near_service: false)
        end
      end
      unless vehicle.last_air_filter_service.nil?
        vehicle.update(near_air_filter_service_mileage: (vehicle.air_filter_service_interval - (vehicle.mileage - vehicle.last_air_filter_service)))
        z = vehicle.near_air_filter_service_mileage
        case 
        when z < 0
          vehicle.update(needs_service: true, air_filter_service: true)
        when z <= @set_air_filter_service.threshold_numb
          vehicle.update(near_service: true)
        else
          vehicle.update(needs_service: false, air_filter_service: false, near_service: false)
        end
      end
    end
  end
end
