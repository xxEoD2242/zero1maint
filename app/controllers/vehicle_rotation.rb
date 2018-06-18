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
        @a_service = (@set_a_service.interval - ((vehicle.mileage + vehicle.est_mileage) - vehicle.last_a_service))
        if @a_service < 0
          vehicle.update(use_b: true, use_a: false, dont_use_a_service: true)
        elsif @a_service <= @set_a_service.threshold_numb
          vehicle.update(use_near_service: true, dont_use_a_service: false)
        else
          vehicle.update(dont_use_a_service: false)
        end
      end

      unless vehicle.last_shock_service.nil?
        @shock_service = (@set_shock_service.interval - ((vehicle.mileage + vehicle.est_mileage) - vehicle.last_shock_service))
        if @shock_service < 0
          vehicle.update(use_b: true, use_a: false, dont_use_shock_service: true)
        elsif @shock_service <= @set_shock_service.threshold_numb
          vehicle.update(use_near_service: true, dont_use_shock_service: false)
        else
          vehicle.update(dont_use_shock_service: false)
        end
      end

      unless vehicle.last_air_filter_service.nil?
        @air_filter_service = (@set_air_filter_service.interval - ((vehicle.mileage + vehicle.est_mileage) - vehicle.last_air_filter_service))
        if @air_filter_service < 0
          vehicle.update(use_b: true, use_a: false, dont_use_air_filter_service: true)
        elsif @air_filter_service <= @set_air_filter_service.threshold_numb
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
        render pdf: "Vehicle Rotation for #{Time.now.strftime('%D')}", layout: 'pdf.pdf.erb', title: "Vehicle Rotation for #{Time.now.strftime('%D')}" # Excluding ".pdf" extension.
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
    @vehicles = Vehicle.all
    @vehicles.all.each do |vehicle|
      unless vehicle.last_a_service.nil?
        @a_service = (@set_a_service.interval - (vehicle.mileage - vehicle.last_a_service))
        if @a_service < 0
          vehicle.update(needs_service: true, a_service: true)
        elsif @a_service <= @set_a_service.threshold_numb
          vehicle.update(near_service: true)
        else
          vehicle.update(needs_service: false, a_service: false, near_service: false)
        end
      end
      unless vehicle.last_shock_service.nil?
        @shock_service = (@set_shock_service.interval - (vehicle.mileage - vehicle.last_shock_service))
        if @shock_service < 0
          vehicle.update(needs_service: true, shock_service: true)
        elsif @shock_service <= @set_shock_service.threshold_numb
          vehicle.update(near_service: true)
        else
          vehicle.update(needs_service: false, shock_service: false, near_service: false)
        end
      end
      # when @vehicle.programs.exists?(7) == true
      next if vehicle.last_air_filter_service.nil?
      @air_filter_service = (@set_air_filter_service.interval - (vehicle.mileage - vehicle.last_air_filter_service))
      if @air_filter_service < 0
        vehicle.update(needs_service: true, air_filter_service: true)
      elsif @air_filter_service <= @set_air_filter_service.threshold_numb
        vehicle.update(near_service: true)
      else
        vehicle.update(needs_service: false, air_filter_service: false, near_service: false)
      end
    end
  end
end
