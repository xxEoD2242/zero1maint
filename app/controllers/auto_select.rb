# frozen_string_literal: true

module Auto_Select
  def auto_select_vehicles
    @event = Event.find(params[:id])
    @use_a =                              Vehicle.where(use_a: true, use_b: false, veh_category: 'RZR', use_near_service: false, location: @event.location)

    # Vehicles that have no future near service or needs service

    # actually Use A vehicles that need service
    @use_b_near_service =                 Vehicle.where(location: @event.location, use_b: false, use_a: true, needs_service: false, near_service: false, veh_category: 'RZR', dont_use_a_service: false, dont_use_shock_service: false, dont_use_air_filter_service: false, use_near_service: true)

    @use_b_air_filter_service_near =      Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: false, near_service: false, veh_category: 'RZR', dont_use_a_service: false, dont_use_shock_service: false, dont_use_air_filter_service: true, use_near_service: false)
    @use_b_a_service_near_1 =             Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: false, near_service: false, veh_category: 'RZR', dont_use_a_service: true, dont_use_shock_service: false, dont_use_air_filter_service: false, use_near_service: false)
    @use_b_shock_service_near_1 =         Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: false, near_service: false, veh_category: 'RZR', dont_use_a_service: false, dont_use_shock_service: true, dont_use_air_filter_service: false, use_near_service: false)

    @use_b_air_filter_service =           Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: false, near_service: false, veh_category: 'RZR', dont_use_a_service: false, dont_use_shock_service: false, dont_use_air_filter_service: true, use_near_service: true)

    @use_b_a_service_near_2 =             Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: false, near_service: false, veh_category: 'RZR', dont_use_a_service: true, dont_use_shock_service: false, dont_use_air_filter_service: true, use_near_service: false)
    @use_b_a_service =                    Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: false, near_service: false, veh_category: 'RZR', dont_use_a_service: true, dont_use_shock_service: false, dont_use_air_filter_service: true, use_near_service: true)

    @use_b_shock_service_near_2 =         Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: false, near_service: false, veh_category: 'RZR', dont_use_a_service: true, dont_use_shock_service: true, dont_use_air_filter_service: true, use_near_service: false)
    @use_b_shock_service =                Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: false, near_service: false, veh_category: 'RZR', dont_use_a_service: true, dont_use_shock_service: true, dont_use_air_filter_service: true, use_near_service: true)

    # Vehicles that Have near service but not needs service
    @use_b_near_service_nas =             Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: false, near_service: true, veh_category: 'RZR', dont_use_a_service: false, dont_use_shock_service: false, dont_use_air_filter_service: false, use_near_service: true)

    @use_b_air_filter_service_near_nas =  Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: false, near_service: true, veh_category: 'RZR', dont_use_a_service: false, dont_use_shock_service: false, dont_use_air_filter_service: true, use_near_service: false)
    @use_b_a_service_near_1_nas =         Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: false, near_service: true, veh_category: 'RZR', dont_use_a_service: true, dont_use_shock_service: false, dont_use_air_filter_service: false, use_near_service: false)
    @use_b_shock_service_near_1_nas =     Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: false, near_service: true, veh_category: 'RZR', dont_use_a_service: false, dont_use_shock_service: true, dont_use_air_filter_service: false, use_near_service: false)

    @use_b_air_filter_service_nas =       Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: false, near_service: true, veh_category: 'RZR', dont_use_a_service: false, dont_use_shock_service: false, dont_use_air_filter_service: true, use_near_service: true)

    @use_b_a_service_near_2_nas =         Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: false, near_service: true, veh_category: 'RZR', dont_use_a_service: true, dont_use_shock_service: false, dont_use_air_filter_service: true, use_near_service: false)
    @use_b_a_service_nas =                Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: false, near_service: true, veh_category: 'RZR', dont_use_a_service: true, dont_use_shock_service: false, dont_use_air_filter_service: true, use_near_service: true)

    @use_b_shock_service_near_2_nas =     Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: false, near_service: true, veh_category: 'RZR', dont_use_a_service: true, dont_use_shock_service: true, dont_use_air_filter_service: true, use_near_service: false)
    @use_b_shock_service_nas =            Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: false, near_service: true, veh_category: 'RZR', dont_use_a_service: true, dont_use_shock_service: true, dont_use_air_filter_service: true, use_near_service: true)

    # Vehicles that have needs service but not near service
    @use_b_near_service_nss =             Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: true, near_service: false, veh_category: 'RZR', dont_use_a_service: false, dont_use_shock_service: false, dont_use_air_filter_service: false, use_near_service: true)

    @use_b_air_filter_service_near_nss =  Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: true, near_service: false, veh_category: 'RZR', dont_use_a_service: false, dont_use_shock_service: false, dont_use_air_filter_service: true, use_near_service: false)
    @use_b_a_service_near_1_nss =         Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: true, near_service: false, veh_category: 'RZR', dont_use_a_service: true, dont_use_shock_service: false, dont_use_air_filter_service: false, use_near_service: false)
    @use_b_shock_service_near_1_nss =     Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: true, near_service: false, veh_category: 'RZR', dont_use_a_service: false, dont_use_shock_service: true, dont_use_air_filter_service: false, use_near_service: false)

    @use_b_air_filter_service_nss =       Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: true, near_service: false, veh_category: 'RZR', dont_use_a_service: false, dont_use_shock_service: false, dont_use_air_filter_service: true, use_near_service: true)

    @use_b_a_service_near_2_nss =         Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: true, near_service: false, veh_category: 'RZR', dont_use_a_service: true, dont_use_shock_service: false, dont_use_air_filter_service: true, use_near_service: false)
    @use_b_a_service_nss =                Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: true, near_service: false, veh_category: 'RZR', dont_use_a_service: true, dont_use_shock_service: false, dont_use_air_filter_service: true, use_near_service: true)

    @use_b_shock_service_near_2_nss =     Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: true, near_service: false, veh_category: 'RZR', dont_use_a_service: true, dont_use_shock_service: true, dont_use_air_filter_service: true, use_near_service: false)
    @use_b_shock_service_nss =            Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: true, near_service: false, veh_category: 'RZR', dont_use_a_service: true, dont_use_shock_service: true, dont_use_air_filter_service: true, use_near_service: true)

    # Vehicles that have needs service and near service
    @use_b_near_service_nass =            Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: true, near_service: true, veh_category: 'RZR', dont_use_a_service: false, dont_use_shock_service: false, dont_use_air_filter_service: false, use_near_service: true)

    @use_b_air_filter_service_near_nass = Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: true, near_service: true, veh_category: 'RZR', dont_use_a_service: false, dont_use_shock_service: false, dont_use_air_filter_service: true, use_near_service: false)
    @use_b_a_service_near_1_nass =        Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: true, near_service: true, veh_category: 'RZR', dont_use_a_service: true, dont_use_shock_service: false, dont_use_air_filter_service: false, use_near_service: false)
    @use_b_shock_service_near_1_nass =    Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: true, near_service: true, veh_category: 'RZR', dont_use_a_service: false, dont_use_shock_service: true, dont_use_air_filter_service: false, use_near_service: false)

    @use_b_air_filter_service_nass =      Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: true, near_service: true, veh_category: 'RZR', dont_use_a_service: false, dont_use_shock_service: false, dont_use_air_filter_service: true, use_near_service: true)

    @use_b_a_service_near_2_nass =        Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: true, near_service: true, veh_category: 'RZR', dont_use_a_service: true, dont_use_shock_service: false, dont_use_air_filter_service: true, use_near_service: false)
    @use_b_a_service_nass =               Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: true, near_service: true, veh_category: 'RZR', dont_use_a_service: true, dont_use_shock_service: false, dont_use_air_filter_service: true, use_near_service: true)

    @use_b_shock_service_near_2_nass =    Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: true, near_service: true, veh_category: 'RZR', dont_use_a_service: true, dont_use_shock_service: true, dont_use_air_filter_service: true, use_near_service: false)
    @use_b_shock_service_nass =           Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: false, near_service: true, veh_category: 'RZR', dont_use_a_service: true, dont_use_shock_service: true, dont_use_air_filter_service: true, use_near_service: true)

    @people = @event.customers
    @shares = @event.shares
    @event_vehicles = []

    unless @people.nil?
      @numb_vehicles = if !@shares.nil?
                         (@people - (@shares * 2)) + @shares
                       else
                         @people
                     end
    end

    @a = (@numb_vehicles - @use_a.all.count)
    @b = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count)
    @c = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count)
    @d = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count)
    @e = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count)
    @f = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count)
    @g = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count)
    @h = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count - @use_b_a_service.all.count)
    @i = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count - @use_b_a_service.all.count - @use_b_shock_service_near_2.all.count)
    @j = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count - @use_b_a_service.all.count - @use_b_shock_service_near_2.all.count - @use_b_shock_service.all.count)
    @k = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count - @use_b_a_service.all.count - @use_b_shock_service_near_2.all.count - @use_b_shock_service.all.count - @use_b_near_service_nas.all.count)
    @l = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count - @use_b_a_service.all.count - @use_b_shock_service_near_2.all.count - @use_b_shock_service.all.count - @use_b_near_service_nas.all.count - @use_b_air_filter_service_nas.all.count)
    @m = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count - @use_b_a_service.all.count - @use_b_shock_service_near_2.all.count - @use_b_shock_service.all.count - @use_b_near_service_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_1_nas.all.count)
    @n = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count - @use_b_a_service.all.count - @use_b_shock_service_near_2.all.count - @use_b_shock_service.all.count - @use_b_near_service_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_1_nas.all.count - @use_b_shock_service_near_1_nas.all.count)
    @o = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count - @use_b_a_service.all.count - @use_b_shock_service_near_2.all.count - @use_b_shock_service.all.count - @use_b_near_service_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_1_nas.all.count - @use_b_shock_service_near_1_nas.all.count - @use_b_air_filter_service_nas.all.count)
    @p = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count - @use_b_a_service.all.count - @use_b_shock_service_near_2.all.count - @use_b_shock_service.all.count - @use_b_near_service_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_1_nas.all.count - @use_b_shock_service_near_1_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_2_nas.all.count)
    @q = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count - @use_b_a_service.all.count - @use_b_shock_service_near_2.all.count - @use_b_shock_service.all.count - @use_b_near_service_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_1_nas.all.count - @use_b_shock_service_near_1_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_2_nas.all.count - @use_b_a_service_nas.all.count)
    @r = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count - @use_b_a_service.all.count - @use_b_shock_service_near_2.all.count - @use_b_shock_service.all.count - @use_b_near_service_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_1_nas.all.count - @use_b_shock_service_near_1_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_2_nas.all.count - @use_b_a_service_nas.all.count - @use_b_shock_service_near_2_nas.all.count)
    @s = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count - @use_b_a_service.all.count - @use_b_shock_service_near_2.all.count - @use_b_shock_service.all.count - @use_b_near_service_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_1_nas.all.count - @use_b_shock_service_near_1_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_2_nas.all.count - @use_b_a_service_nas.all.count - @use_b_shock_service_near_2_nas.all.count - @use_b_shock_service_nas.all.count)
    @t = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count - @use_b_a_service.all.count - @use_b_shock_service_near_2.all.count - @use_b_shock_service.all.count - @use_b_near_service_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_1_nas.all.count - @use_b_shock_service_near_1_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_2_nas.all.count - @use_b_a_service_nas.all.count - @use_b_shock_service_near_2_nas.all.count - @use_b_shock_service_nas.all.count - @use_b_near_service_nss.all.count)
    @u = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count - @use_b_a_service.all.count - @use_b_shock_service_near_2.all.count - @use_b_shock_service.all.count - @use_b_near_service_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_1_nas.all.count - @use_b_shock_service_near_1_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_2_nas.all.count - @use_b_a_service_nas.all.count - @use_b_shock_service_near_2_nas.all.count - @use_b_shock_service_nas.all.count - @use_b_near_service_nss.all.count - @use_b_air_filter_service_near_nss.all.count)
    @v = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count - @use_b_a_service.all.count - @use_b_shock_service_near_2.all.count - @use_b_shock_service.all.count - @use_b_near_service_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_1_nas.all.count - @use_b_shock_service_near_1_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_2_nas.all.count - @use_b_a_service_nas.all.count - @use_b_shock_service_near_2_nas.all.count - @use_b_shock_service_nas.all.count - @use_b_near_service_nss.all.count - @use_b_air_filter_service_near_nss.all.count - @use_b_a_service_near_1_nss.all.count)
    @w = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count - @use_b_a_service.all.count - @use_b_shock_service_near_2.all.count - @use_b_shock_service.all.count - @use_b_near_service_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_1_nas.all.count - @use_b_shock_service_near_1_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_2_nas.all.count - @use_b_a_service_nas.all.count - @use_b_shock_service_near_2_nas.all.count - @use_b_shock_service_nas.all.count - @use_b_near_service_nss.all.count - @use_b_air_filter_service_near_nss.all.count - @use_b_a_service_near_1_nss.all.count - @use_b_shock_service_near_1_nss.all.count)
    @x = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count - @use_b_a_service.all.count - @use_b_shock_service_near_2.all.count - @use_b_shock_service.all.count - @use_b_near_service_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_1_nas.all.count - @use_b_shock_service_near_1_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_2_nas.all.count - @use_b_a_service_nas.all.count - @use_b_shock_service_near_2_nas.all.count - @use_b_shock_service_nas.all.count - @use_b_near_service_nss.all.count - @use_b_air_filter_service_near_nss.all.count - @use_b_a_service_near_1_nss.all.count - @use_b_shock_service_near_1_nss.all.count - @use_b_air_filter_service_nss.all.count)
    @y = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count - @use_b_a_service.all.count - @use_b_shock_service_near_2.all.count - @use_b_shock_service.all.count - @use_b_near_service_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_1_nas.all.count - @use_b_shock_service_near_1_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_2_nas.all.count - @use_b_a_service_nas.all.count - @use_b_shock_service_near_2_nas.all.count - @use_b_shock_service_nas.all.count - @use_b_near_service_nss.all.count - @use_b_air_filter_service_near_nss.all.count - @use_b_a_service_near_1_nss.all.count - @use_b_shock_service_near_1_nss.all.count - @use_b_air_filter_service_nss.all.count - @use_b_a_service_near_2_nss.all.count)
    @z = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count - @use_b_a_service.all.count - @use_b_shock_service_near_2.all.count - @use_b_shock_service.all.count - @use_b_near_service_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_1_nas.all.count - @use_b_shock_service_near_1_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_2_nas.all.count - @use_b_a_service_nas.all.count - @use_b_shock_service_near_2_nas.all.count - @use_b_shock_service_nas.all.count - @use_b_near_service_nss.all.count - @use_b_air_filter_service_near_nss.all.count - @use_b_a_service_near_1_nss.all.count - @use_b_shock_service_near_1_nss.all.count - @use_b_air_filter_service_nss.all.count - @use_b_a_service_near_2_nss.all.count - @use_b_a_service_nss.all.count)
    @aa = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count - @use_b_a_service.all.count - @use_b_shock_service_near_2.all.count - @use_b_shock_service.all.count - @use_b_near_service_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_1_nas.all.count - @use_b_shock_service_near_1_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_2_nas.all.count - @use_b_a_service_nas.all.count - @use_b_shock_service_near_2_nas.all.count - @use_b_shock_service_nas.all.count - @use_b_near_service_nss.all.count - @use_b_air_filter_service_near_nss.all.count - @use_b_a_service_near_1_nss.all.count - @use_b_shock_service_near_1_nss.all.count - @use_b_air_filter_service_nss.all.count - @use_b_a_service_near_2_nss.all.count - @use_b_a_service_nss.all.count - @use_b_shock_service_near_2_nss.all.count)
    @ab = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count - @use_b_a_service.all.count - @use_b_shock_service_near_2.all.count - @use_b_shock_service.all.count - @use_b_near_service_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_1_nas.all.count - @use_b_shock_service_near_1_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_2_nas.all.count - @use_b_a_service_nas.all.count - @use_b_shock_service_near_2_nas.all.count - @use_b_shock_service_nas.all.count - @use_b_near_service_nss.all.count - @use_b_air_filter_service_near_nss.all.count - @use_b_a_service_near_1_nss.all.count - @use_b_shock_service_near_1_nss.all.count - @use_b_air_filter_service_nss.all.count - @use_b_a_service_near_2_nss.all.count - @use_b_a_service_nss.all.count - @use_b_shock_service_near_2_nss.all.count - @use_b_shock_service_nss.all.count)
    @ac = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count - @use_b_a_service.all.count - @use_b_shock_service_near_2.all.count - @use_b_shock_service.all.count - @use_b_near_service_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_1_nas.all.count - @use_b_shock_service_near_1_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_2_nas.all.count - @use_b_a_service_nas.all.count - @use_b_shock_service_near_2_nas.all.count - @use_b_shock_service_nas.all.count - @use_b_near_service_nss.all.count - @use_b_air_filter_service_near_nss.all.count - @use_b_a_service_near_1_nss.all.count - @use_b_shock_service_near_1_nss.all.count - @use_b_air_filter_service_nss.all.count - @use_b_a_service_near_2_nss.all.count - @use_b_a_service_nss.all.count - @use_b_shock_service_near_2_nss.all.count - @use_b_shock_service_nss.all.count - @use_b_near_service_nass.all.count)
    @ad = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count - @use_b_a_service.all.count - @use_b_shock_service_near_2.all.count - @use_b_shock_service.all.count - @use_b_near_service_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_1_nas.all.count - @use_b_shock_service_near_1_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_2_nas.all.count - @use_b_a_service_nas.all.count - @use_b_shock_service_near_2_nas.all.count - @use_b_shock_service_nas.all.count - @use_b_near_service_nss.all.count - @use_b_air_filter_service_near_nss.all.count - @use_b_a_service_near_1_nss.all.count - @use_b_shock_service_near_1_nss.all.count - @use_b_air_filter_service_nss.all.count - @use_b_a_service_near_2_nss.all.count - @use_b_a_service_nss.all.count - @use_b_shock_service_near_2_nss.all.count - @use_b_shock_service_nss.all.count - @use_b_near_service_nass.all.count - @use_b_air_filter_service_near_nass.all.count)
    @ae = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count - @use_b_a_service.all.count - @use_b_shock_service_near_2.all.count - @use_b_shock_service.all.count - @use_b_near_service_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_1_nas.all.count - @use_b_shock_service_near_1_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_2_nas.all.count - @use_b_a_service_nas.all.count - @use_b_shock_service_near_2_nas.all.count - @use_b_shock_service_nas.all.count - @use_b_near_service_nss.all.count - @use_b_air_filter_service_near_nss.all.count - @use_b_a_service_near_1_nss.all.count - @use_b_shock_service_near_1_nss.all.count - @use_b_air_filter_service_nss.all.count - @use_b_a_service_near_2_nss.all.count - @use_b_a_service_nss.all.count - @use_b_shock_service_near_2_nss.all.count - @use_b_shock_service_nss.all.count - @use_b_near_service_nass.all.count - @use_b_air_filter_service_near_nass.all.count - @use_b_a_service_near_1_nass.all.count)
    @af = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count - @use_b_a_service.all.count - @use_b_shock_service_near_2.all.count - @use_b_shock_service.all.count - @use_b_near_service_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_1_nas.all.count - @use_b_shock_service_near_1_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_2_nas.all.count - @use_b_a_service_nas.all.count - @use_b_shock_service_near_2_nas.all.count - @use_b_shock_service_nas.all.count - @use_b_near_service_nss.all.count - @use_b_air_filter_service_near_nss.all.count - @use_b_a_service_near_1_nss.all.count - @use_b_shock_service_near_1_nss.all.count - @use_b_air_filter_service_nss.all.count - @use_b_a_service_near_2_nss.all.count - @use_b_a_service_nss.all.count - @use_b_shock_service_near_2_nss.all.count - @use_b_shock_service_nss.all.count - @use_b_near_service_nass.all.count - @use_b_air_filter_service_near_nass.all.count - @use_b_a_service_near_1_nass.all.count - @use_b_shock_service_near_1_nass.all.count)
    @ag = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count - @use_b_a_service.all.count - @use_b_shock_service_near_2.all.count - @use_b_shock_service.all.count - @use_b_near_service_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_1_nas.all.count - @use_b_shock_service_near_1_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_2_nas.all.count - @use_b_a_service_nas.all.count - @use_b_shock_service_near_2_nas.all.count - @use_b_shock_service_nas.all.count - @use_b_near_service_nss.all.count - @use_b_air_filter_service_near_nss.all.count - @use_b_a_service_near_1_nss.all.count - @use_b_shock_service_near_1_nss.all.count - @use_b_air_filter_service_nss.all.count - @use_b_a_service_near_2_nss.all.count - @use_b_a_service_nss.all.count - @use_b_shock_service_near_2_nss.all.count - @use_b_shock_service_nss.all.count - @use_b_near_service_nass.all.count - @use_b_air_filter_service_near_nass.all.count - @use_b_a_service_near_1_nass.all.count - @use_b_shock_service_near_1_nass.all.count - @use_b_air_filter_service_nass.all.count)
    @ah = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count - @use_b_a_service.all.count - @use_b_shock_service_near_2.all.count - @use_b_shock_service.all.count - @use_b_near_service_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_1_nas.all.count - @use_b_shock_service_near_1_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_2_nas.all.count - @use_b_a_service_nas.all.count - @use_b_shock_service_near_2_nas.all.count - @use_b_shock_service_nas.all.count - @use_b_near_service_nss.all.count - @use_b_air_filter_service_near_nss.all.count - @use_b_a_service_near_1_nss.all.count - @use_b_shock_service_near_1_nss.all.count - @use_b_air_filter_service_nss.all.count - @use_b_a_service_near_2_nss.all.count - @use_b_a_service_nss.all.count - @use_b_shock_service_near_2_nss.all.count - @use_b_shock_service_nss.all.count - @use_b_near_service_nass.all.count - @use_b_air_filter_service_near_nass.all.count - @use_b_a_service_near_1_nass.all.count - @use_b_shock_service_near_1_nass.all.count - @use_b_air_filter_service_nass.all.count - @use_b_a_service_near_2_nass.all.count)
    @ai = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count - @use_b_a_service.all.count - @use_b_shock_service_near_2.all.count - @use_b_shock_service.all.count - @use_b_near_service_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_1_nas.all.count - @use_b_shock_service_near_1_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_2_nas.all.count - @use_b_a_service_nas.all.count - @use_b_shock_service_near_2_nas.all.count - @use_b_shock_service_nas.all.count - @use_b_near_service_nss.all.count - @use_b_air_filter_service_near_nss.all.count - @use_b_a_service_near_1_nss.all.count - @use_b_shock_service_near_1_nss.all.count - @use_b_air_filter_service_nss.all.count - @use_b_a_service_near_2_nss.all.count - @use_b_a_service_nss.all.count - @use_b_shock_service_near_2_nss.all.count - @use_b_shock_service_nss.all.count - @use_b_near_service_nass.all.count - @use_b_air_filter_service_near_nass.all.count - @use_b_a_service_near_1_nass.all.count - @use_b_shock_service_near_1_nass.all.count - @use_b_air_filter_service_nass.all.count - @use_b_a_service_near_2_nass.all.count - @use_b_a_service_nass.all.count)
    @aj = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count - @use_b_a_service.all.count - @use_b_shock_service_near_2.all.count - @use_b_shock_service.all.count - @use_b_near_service_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_1_nas.all.count - @use_b_shock_service_near_1_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_2_nas.all.count - @use_b_a_service_nas.all.count - @use_b_shock_service_near_2_nas.all.count - @use_b_shock_service_nas.all.count - @use_b_near_service_nss.all.count - @use_b_air_filter_service_near_nss.all.count - @use_b_a_service_near_1_nss.all.count - @use_b_shock_service_near_1_nss.all.count - @use_b_air_filter_service_nss.all.count - @use_b_a_service_near_2_nss.all.count - @use_b_a_service_nss.all.count - @use_b_shock_service_near_2_nss.all.count - @use_b_shock_service_nss.all.count - @use_b_near_service_nass.all.count - @use_b_air_filter_service_near_nass.all.count - @use_b_a_service_near_1_nass.all.count - @use_b_shock_service_near_1_nass.all.count - @use_b_air_filter_service_nass.all.count - @use_b_a_service_near_2_nass.all.count - @use_b_a_service_nass.all.count - @use_b_shock_service_near_2_nass.all.count)

    if @event.event_type == 'RZR'

      if @use_a.all.count >= @numb_vehicles
        @use_a.order(times_used: :asc).limit(@numb_vehicles).each do |vehicle|
          @event_vehicles << vehicle.id
        end

      elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count >= @a

        @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
          @event_vehicles << vehicle.id
        end

        @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
          @event_vehicles << vehicle.id
        end

      elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count >= @b

        @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
          @event_vehicles << vehicle.id
        end

        @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
          @event_vehicles << vehicle.id
        end

      elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count >= @c

        @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
          @event_vehicles << vehicle.id
        end

        @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
          @event_vehicles << vehicle.id
        end

      elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count >= @d

        @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
          @event_vehicles << vehicle.id
        end

        @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
          @event_vehicles << vehicle.id
        end

      elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count >= @e

        @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
          @event_vehicles << vehicle.id
        end

        @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
          @event_vehicles << vehicle.id
        end
      elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count >= @f

        @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
          @event_vehicles << vehicle.id
        end

        @use_b_service.order(times_used: :asc).limit(@a).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
          @event_vehicles << vehicle.id
        end
      elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count >= @g

        @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
          @event_vehicles << vehicle.id
        end

        @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
          @event_vehicles << vehicle.id
        end
      elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count < @g && @use_b_shock_service_near_2.all.count >= @h

        @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
          @event_vehicles << vehicle.id
        end

        @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2.order(times_used: :asc).limit(@h).each do |vehicle|
          @event_vehicles << vehicle.id
        end
      elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count < @g && @use_b_shock_service_near_2.all.count < @h && @use_b_shock_service.all.count >= @i

        @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
          @event_vehicles << vehicle.id
        end

        @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2.order(times_used: :asc).limit(@h).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service.order(times_used: :asc).limit(@i).each do |vehicle|
          @event_vehicles << vehicle.id
        end
      elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count < @g && @use_b_shock_service_near_2.all.count < @h && @use_b_shock_service.all.count < @i && @use_b_near_service_nas.all.count >= @j

        @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
          @event_vehicles << vehicle.id
        end

        @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2.order(times_used: :asc).limit(@h).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service.order(times_used: :asc).limit(@i).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_near_service_nas.order(times_used: :asc).limit(@j).each do |vehicle|
          @event_vehicles << vehicle.id
        end
      elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count < @g && @use_b_shock_service_near_2.all.count < @h && @use_b_shock_service.all.count < @i && @use_b_near_service_nas.all.count < @j && @use_b_air_filter_service_near_nas.all.count >= @k

        @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
          @event_vehicles << vehicle.id
        end

        @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2.order(times_used: :asc).limit(@h).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service.order(times_used: :asc).limit(@i).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_near_service_nas.order(times_used: :asc).limit(@j).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near_nas.order(times_used: :asc).limit(@k).each do |vehicle|
          @event_vehicles << vehicle.id
        end
      elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count < @g && @use_b_shock_service_near_2.all.count < @h && @use_b_shock_service.all.count < @i && @use_b_near_service_nas.all.count < @j && @use_b_air_filter_service_near_nas.all.count < @k && @use_b_a_service_near_1_nas.all.count >= @l

        @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
          @event_vehicles << vehicle.id
        end

        @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2.order(times_used: :asc).limit(@h).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service.order(times_used: :asc).limit(@i).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_near_service_nas.order(times_used: :asc).limit(@j).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near_nas.order(times_used: :asc).limit(@k).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1_nas.order(times_used: :asc).limit(@l).each do |vehicle|
          @event_vehicles << vehicle.id
        end
      elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count < @g && @use_b_shock_service_near_2.all.count < @h && @use_b_shock_service.all.count < @i && @use_b_near_service_nas.all.count < @j && @use_b_air_filter_service_near_nas.all.count < @k && @use_b_a_service_near_1_nas.all.count < @l && @use_b_shock_service_near_1_nas.all.count >= @m

        @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
          @event_vehicles << vehicle.id
        end

        @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2.order(times_used: :asc).limit(@h).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service.order(times_used: :asc).limit(@i).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_near_service_nas.order(times_used: :asc).limit(@j).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near_nas.order(times_used: :asc).limit(@k).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1_nas.order(times_used: :asc).limit(@l).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1_nas.order(times_used: :asc).limit(@m).each do |vehicle|
          @event_vehicles << vehicle.id
        end
      elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count < @g && @use_b_shock_service_near_2.all.count < @h && @use_b_shock_service.all.count < @i && @use_b_near_service_nas.all.count < @j && @use_b_air_filter_service_near_nas.all.count < @k && @use_b_a_service_near_1_nas.all.count < @l && @use_b_shock_service_near_1_nas.all.count < @m && @use_b_air_filter_service_nas.all.count >= @n

        @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
          @event_vehicles << vehicle.id
        end

        @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2.order(times_used: :asc).limit(@h).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service.order(times_used: :asc).limit(@i).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_near_service_nas.order(times_used: :asc).limit(@j).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near_nas.order(times_used: :asc).limit(@k).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1_nas.order(times_used: :asc).limit(@l).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1_nas.order(times_used: :asc).limit(@m).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_nas.order(times_used: :asc).limit(@n).each do |vehicle|
          @event_vehicles << vehicle.id
        end
      elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count < @g && @use_b_shock_service_near_2.all.count < @h && @use_b_shock_service.all.count < @i && @use_b_near_service_nas.all.count < @j && @use_b_air_filter_service_near_nas.all.count < @k && @use_b_a_service_near_1_nas.all.count < @l && @use_b_shock_service_near_1_nas.all.count < @m && @use_b_air_filter_service_nas.all.count < @n && @use_b_a_service_near_2_nas.all.count >= @o

        @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
          @event_vehicles << vehicle.id
        end

        @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2.order(times_used: :asc).limit(@h).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service.order(times_used: :asc).limit(@i).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_near_service_nas.order(times_used: :asc).limit(@j).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near_nas.order(times_used: :asc).limit(@k).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1_nas.order(times_used: :asc).limit(@l).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1_nas.order(times_used: :asc).limit(@m).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_nas.order(times_used: :asc).limit(@n).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2_nas.order(times_used: :asc).limit(@o).each do |vehicle|
          @event_vehicles << vehicle.id
        end
      elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count < @g && @use_b_shock_service_near_2.all.count < @h && @use_b_shock_service.all.count < @i && @use_b_near_service_nas.all.count < @j && @use_b_air_filter_service_near_nas.all.count < @k && @use_b_a_service_near_1_nas.all.count < @l && @use_b_shock_service_near_1_nas.all.count < @m && @use_b_air_filter_service_nas.all.count < @n && @use_b_a_service_near_2_nas.all.count < @o && @use_b_a_service_nas.all.count >= @p

        @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
          @event_vehicles << vehicle.id
        end

        @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2.order(times_used: :asc).limit(@h).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service.order(times_used: :asc).limit(@i).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_near_service_nas.order(times_used: :asc).limit(@j).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near_nas.order(times_used: :asc).limit(@k).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1_nas.order(times_used: :asc).limit(@l).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1_nas.order(times_used: :asc).limit(@m).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_nas.order(times_used: :asc).limit(@n).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2_nas.order(times_used: :asc).limit(@o).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_nas.order(times_used: :asc).limit(@p).each do |vehicle|
          @event_vehicles << vehicle.id
        end
      elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count < @g && @use_b_shock_service_near_2.all.count < @h && @use_b_shock_service.all.count < @i && @use_b_near_service_nas.all.count < @j && @use_b_air_filter_service_near_nas.all.count < @k && @use_b_a_service_near_1_nas.all.count < @l && @use_b_shock_service_near_1_nas.all.count < @m && @use_b_air_filter_service_nas.all.count < @n && @use_b_a_service_near_2_nas.all.count < @o && @use_b_a_service_nas.all.count < @p && @use_b_shock_service_near_2_nas.all.count >= @q

        @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
          @event_vehicles << vehicle.id
        end

        @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2.order(times_used: :asc).limit(@h).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service.order(times_used: :asc).limit(@i).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_near_service_nas.order(times_used: :asc).limit(@j).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near_nas.order(times_used: :asc).limit(@k).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1_nas.order(times_used: :asc).limit(@l).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1_nas.order(times_used: :asc).limit(@m).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_nas.order(times_used: :asc).limit(@n).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2_nas.order(times_used: :asc).limit(@o).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_nas.order(times_used: :asc).limit(@p).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2_nas.order(times_used: :asc).limit(@q).each do |vehicle|
          @event_vehicles << vehicle.id
        end
      elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count < @g && @use_b_shock_service_near_2.all.count < @h && @use_b_shock_service.all.count < @i && @use_b_near_service_nas.all.count < @j && @use_b_air_filter_service_near_nas.all.count < @k && @use_b_a_service_near_1_nas.all.count < @l && @use_b_shock_service_near_1_nas.all.count < @m && @use_b_air_filter_service_nas.all.count < @n && @use_b_a_service_near_2_nas.all.count < @o && @use_b_a_service_nas.all.count < @p && @use_b_shock_service_near_2_nas.all.count < @q && @use_b_shock_service_nas.all.count >= @r

        @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
          @event_vehicles << vehicle.id
        end

        @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2.order(times_used: :asc).limit(@h).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service.order(times_used: :asc).limit(@i).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_near_service_nas.order(times_used: :asc).limit(@j).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near_nas.order(times_used: :asc).limit(@k).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1_nas.order(times_used: :asc).limit(@l).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1_nas.order(times_used: :asc).limit(@m).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_nas.order(times_used: :asc).limit(@n).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2_nas.order(times_used: :asc).limit(@o).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_nas.order(times_used: :asc).limit(@p).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2_nas.order(times_used: :asc).limit(@q).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_nas.order(times_used: :asc).limit(@r).each do |vehicle|
          @event_vehicles << vehicle.id
        end
      elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count < @g && @use_b_shock_service_near_2.all.count < @h && @use_b_shock_service.all.count < @i && @use_b_near_service_nas.all.count < @j && @use_b_air_filter_service_near_nas.all.count < @k && @use_b_a_service_near_1_nas.all.count < @l && @use_b_shock_service_near_1_nas.all.count < @m && @use_b_air_filter_service_nas.all.count < @n && @use_b_a_service_near_2_nas.all.count < @o && @use_b_a_service_nas.all.count < @p && @use_b_shock_service_near_2_nas.all.count < @q && @use_b_shock_service_nas.all.count < @r && @use_b_near_service_nss.all.count >= @s

        @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
          @event_vehicles << vehicle.id
        end

        @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2.order(times_used: :asc).limit(@h).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service.order(times_used: :asc).limit(@i).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_near_service_nas.order(times_used: :asc).limit(@j).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near_nas.order(times_used: :asc).limit(@k).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1_nas.order(times_used: :asc).limit(@l).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1_nas.order(times_used: :asc).limit(@m).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_nas.order(times_used: :asc).limit(@n).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2_nas.order(times_used: :asc).limit(@o).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_nas.order(times_used: :asc).limit(@p).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2_nas.order(times_used: :asc).limit(@q).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_nas.order(times_used: :asc).limit(@r).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_near_service_nss.order(times_used: :asc).limit(@s).each do |vehicle|
          @event_vehicles << vehicle.id
        end
      elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count < @g && @use_b_shock_service_near_2.all.count < @h && @use_b_shock_service.all.count < @i && @use_b_near_service_nas.all.count < @j && @use_b_air_filter_service_near_nas.all.count < @k && @use_b_a_service_near_1_nas.all.count < @l && @use_b_shock_service_near_1_nas.all.count < @m && @use_b_air_filter_service_nas.all.count < @n && @use_b_a_service_near_2_nas.all.count < @o && @use_b_a_service_nas.all.count < @p && @use_b_shock_service_near_2_nas.all.count < @q && @use_b_shock_service_nas.all.count < @r && @use_b_near_service_nss.all.count < @s && @use_b_air_filter_service_near_nss.all.count >= @t

        @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
          @event_vehicles << vehicle.id
        end

        @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2.order(times_used: :asc).limit(@h).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service.order(times_used: :asc).limit(@i).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_near_service_nas.order(times_used: :asc).limit(@j).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near_nas.order(times_used: :asc).limit(@k).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1_nas.order(times_used: :asc).limit(@l).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1_nas.order(times_used: :asc).limit(@m).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_nas.order(times_used: :asc).limit(@n).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2_nas.order(times_used: :asc).limit(@o).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_nas.order(times_used: :asc).limit(@p).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2_nas.order(times_used: :asc).limit(@q).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_nas.order(times_used: :asc).limit(@r).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_near_service_nss.order(times_used: :asc).limit(@s).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near_nss.order(times_used: :asc).limit(@t).each do |vehicle|
          @event_vehicles << vehicle.id
        end
      elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count < @g && @use_b_shock_service_near_2.all.count < @h && @use_b_shock_service.all.count < @i && @use_b_near_service_nas.all.count < @j && @use_b_air_filter_service_near_nas.all.count < @k && @use_b_a_service_near_1_nas.all.count < @l && @use_b_shock_service_near_1_nas.all.count < @m && @use_b_air_filter_service_nas.all.count < @n && @use_b_a_service_near_2_nas.all.count < @o && @use_b_a_service_nas.all.count < @p && @use_b_shock_service_near_2_nas.all.count < @q && @use_b_shock_service_nas.all.count < @r && @use_b_near_service_nss.all.count < @s && @use_b_air_filter_service_near_nss.all.count < @t && @use_b_a_service_near_1_nss.all.count >= @u

        @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
          @event_vehicles << vehicle.id
        end

        @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2.order(times_used: :asc).limit(@h).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service.order(times_used: :asc).limit(@i).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_near_service_nas.order(times_used: :asc).limit(@j).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near_nas.order(times_used: :asc).limit(@k).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1_nas.order(times_used: :asc).limit(@l).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1_nas.order(times_used: :asc).limit(@m).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_nas.order(times_used: :asc).limit(@n).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2_nas.order(times_used: :asc).limit(@o).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_nas.order(times_used: :asc).limit(@p).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2_nas.order(times_used: :asc).limit(@q).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_nas.order(times_used: :asc).limit(@r).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_near_service_nss.order(times_used: :asc).limit(@s).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near_nss.order(times_used: :asc).limit(@t).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1_nss.order(times_used: :asc).limit(@u).each do |vehicle|
          @event_vehicles << vehicle.id
        end
      elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count < @g && @use_b_shock_service_near_2.all.count < @h && @use_b_shock_service.all.count < @i && @use_b_near_service_nas.all.count < @j && @use_b_air_filter_service_near_nas.all.count < @k && @use_b_a_service_near_1_nas.all.count < @l && @use_b_shock_service_near_1_nas.all.count < @m && @use_b_air_filter_service_nas.all.count < @n && @use_b_a_service_near_2_nas.all.count < @o && @use_b_a_service_nas.all.count < @p && @use_b_shock_service_near_2_nas.all.count < @q && @use_b_shock_service_nas.all.count < @r && @use_b_near_service_nss.all.count < @s && @use_b_air_filter_service_near_nss.all.count < @t && @use_b_a_service_near_1_nss.all.count < @u && @use_b_shock_service_near_1_nss.all.count >= @v

        @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
          @event_vehicles << vehicle.id
        end

        @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2.order(times_used: :asc).limit(@h).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service.order(times_used: :asc).limit(@i).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_near_service_nas.order(times_used: :asc).limit(@j).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near_nas.order(times_used: :asc).limit(@k).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1_nas.order(times_used: :asc).limit(@l).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1_nas.order(times_used: :asc).limit(@m).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_nas.order(times_used: :asc).limit(@n).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2_nas.order(times_used: :asc).limit(@o).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_nas.order(times_used: :asc).limit(@p).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2_nas.order(times_used: :asc).limit(@q).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_nas.order(times_used: :asc).limit(@r).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_near_service_nss.order(times_used: :asc).limit(@s).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near_nss.order(times_used: :asc).limit(@t).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1_nss.order(times_used: :asc).limit(@u).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1_nss.order(times_used: :asc).limit(@v).each do |vehicle|
          @event_vehicles << vehicle.id
        end
      elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count < @g && @use_b_shock_service_near_2.all.count < @h && @use_b_shock_service.all.count < @i && @use_b_near_service_nas.all.count < @j && @use_b_air_filter_service_near_nas.all.count < @k && @use_b_a_service_near_1_nas.all.count < @l && @use_b_shock_service_near_1_nas.all.count < @m && @use_b_air_filter_service_nas.all.count < @n && @use_b_a_service_near_2_nas.all.count < @o && @use_b_a_service_nas.all.count < @p && @use_b_shock_service_near_2_nas.all.count < @q && @use_b_shock_service_nas.all.count < @r && @use_b_near_service_nss.all.count < @s && @use_b_air_filter_service_near_nss.all.count < @t && @use_b_a_service_near_1_nss.all.count < @u && @use_b_shock_service_near_1_nss.all.count < @v && @use_b_air_filter_service_nss.all.count >= @w

        @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
          @event_vehicles << vehicle.id
        end

        @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2.order(times_used: :asc).limit(@h).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service.order(times_used: :asc).limit(@i).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_near_service_nas.order(times_used: :asc).limit(@j).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near_nas.order(times_used: :asc).limit(@k).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1_nas.order(times_used: :asc).limit(@l).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1_nas.order(times_used: :asc).limit(@m).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_nas.order(times_used: :asc).limit(@n).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2_nas.order(times_used: :asc).limit(@o).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_nas.order(times_used: :asc).limit(@p).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2_nas.order(times_used: :asc).limit(@q).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_nas.order(times_used: :asc).limit(@r).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_near_service_nss.order(times_used: :asc).limit(@s).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near_nss.order(times_used: :asc).limit(@t).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1_nss.order(times_used: :asc).limit(@u).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1_nss.order(times_used: :asc).limit(@v).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_nss.order(times_used: :asc).limit(@w).each do |vehicle|
          @event_vehicles << vehicle.id
        end
      elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count < @g && @use_b_shock_service_near_2.all.count < @h && @use_b_shock_service.all.count < @i && @use_b_near_service_nas.all.count < @j && @use_b_air_filter_service_near_nas.all.count < @k && @use_b_a_service_near_1_nas.all.count < @l && @use_b_shock_service_near_1_nas.all.count < @m && @use_b_air_filter_service_nas.all.count < @n && @use_b_a_service_near_2_nas.all.count < @o && @use_b_a_service_nas.all.count < @p && @use_b_shock_service_near_2_nas.all.count < @q && @use_b_shock_service_nas.all.count < @r && @use_b_near_service_nss.all.count < @s && @use_b_air_filter_service_near_nss.all.count < @t && @use_b_a_service_near_1_nss.all.count < @u && @use_b_shock_service_near_1_nss.all.count < @v && @use_b_air_filter_service_nss.all.count < @w && @use_b_a_service_near_2_nss.all.count >= @x

        @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
          @event_vehicles << vehicle.id
        end

        @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2.order(times_used: :asc).limit(@h).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service.order(times_used: :asc).limit(@i).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_near_service_nas.order(times_used: :asc).limit(@j).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near_nas.order(times_used: :asc).limit(@k).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1_nas.order(times_used: :asc).limit(@l).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1_nas.order(times_used: :asc).limit(@m).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_nas.order(times_used: :asc).limit(@n).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2_nas.order(times_used: :asc).limit(@o).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_nas.order(times_used: :asc).limit(@p).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2_nas.order(times_used: :asc).limit(@q).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_nas.order(times_used: :asc).limit(@r).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_near_service_nss.order(times_used: :asc).limit(@s).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near_nss.order(times_used: :asc).limit(@t).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1_nss.order(times_used: :asc).limit(@u).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1_nss.order(times_used: :asc).limit(@v).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_nss.order(times_used: :asc).limit(@w).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2_nss.order(times_used: :asc).limit(@x).each do |vehicle|
          @event_vehicles << vehicle.id
        end
      elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count < @g && @use_b_shock_service_near_2.all.count < @h && @use_b_shock_service.all.count < @i && @use_b_near_service_nas.all.count < @j && @use_b_air_filter_service_near_nas.all.count < @k && @use_b_a_service_near_1_nas.all.count < @l && @use_b_shock_service_near_1_nas.all.count < @m && @use_b_air_filter_service_nas.all.count < @n && @use_b_a_service_near_2_nas.all.count < @o && @use_b_a_service_nas.all.count < @p && @use_b_shock_service_near_2_nas.all.count < @q && @use_b_shock_service_nas.all.count < @r && @use_b_near_service_nss.all.count < @s && @use_b_air_filter_service_near_nss.all.count < @t && @use_b_a_service_near_1_nss.all.count < @u && @use_b_shock_service_near_1_nss.all.count < @v && @use_b_air_filter_service_nss.all.count < @w && @use_b_a_service_near_2_nss.all.count < @x && @use_b_a_service_nss.all.count >= @y

        @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
          @event_vehicles << vehicle.id
        end

        @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2.order(times_used: :asc).limit(@h).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service.order(times_used: :asc).limit(@i).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_near_service_nas.order(times_used: :asc).limit(@j).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near_nas.order(times_used: :asc).limit(@k).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1_nas.order(times_used: :asc).limit(@l).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1_nas.order(times_used: :asc).limit(@m).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_nas.order(times_used: :asc).limit(@n).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2_nas.order(times_used: :asc).limit(@o).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_nas.order(times_used: :asc).limit(@p).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2_nas.order(times_used: :asc).limit(@q).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_nas.order(times_used: :asc).limit(@r).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_near_service_nss.order(times_used: :asc).limit(@s).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near_nss.order(times_used: :asc).limit(@t).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1_nss.order(times_used: :asc).limit(@u).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1_nss.order(times_used: :asc).limit(@v).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_nss.order(times_used: :asc).limit(@w).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2_nss.order(times_used: :asc).limit(@x).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_nss.order(times_used: :asc).limit(@y).each do |vehicle|
          @event_vehicles << vehicle.id
        end
      elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count < @g && @use_b_shock_service_near_2.all.count < @h && @use_b_shock_service.all.count < @i && @use_b_near_service_nas.all.count < @j && @use_b_air_filter_service_near_nas.all.count < @k && @use_b_a_service_near_1_nas.all.count < @l && @use_b_shock_service_near_1_nas.all.count < @m && @use_b_air_filter_service_nas.all.count < @n && @use_b_a_service_near_2_nas.all.count < @o && @use_b_a_service_nas.all.count < @p && @use_b_shock_service_near_2_nas.all.count < @q && @use_b_shock_service_nas.all.count < @r && @use_b_near_service_nss.all.count < @s && @use_b_air_filter_service_near_nss.all.count < @t && @use_b_a_service_near_1_nss.all.count < @u && @use_b_shock_service_near_1_nss.all.count < @v && @use_b_air_filter_service_nss.all.count < @w && @use_b_a_service_near_2_nss.all.count < @x && @use_b_a_service_nss.all.count < @y && @use_b_shock_service_near_2_nss.all.count >= @z

        @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
          @event_vehicles << vehicle.id
        end

        @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2.order(times_used: :asc).limit(@h).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service.order(times_used: :asc).limit(@i).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_near_service_nas.order(times_used: :asc).limit(@j).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near_nas.order(times_used: :asc).limit(@k).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1_nas.order(times_used: :asc).limit(@l).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1_nas.order(times_used: :asc).limit(@m).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_nas.order(times_used: :asc).limit(@n).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2_nas.order(times_used: :asc).limit(@o).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_nas.order(times_used: :asc).limit(@p).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2_nas.order(times_used: :asc).limit(@q).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_nas.order(times_used: :asc).limit(@r).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_near_service_nss.order(times_used: :asc).limit(@s).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near_nss.order(times_used: :asc).limit(@t).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1_nss.order(times_used: :asc).limit(@u).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1_nss.order(times_used: :asc).limit(@v).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_nss.order(times_used: :asc).limit(@w).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2_nss.order(times_used: :asc).limit(@x).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_nss.order(times_used: :asc).limit(@y).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2_nss.order(times_used: :asc).limit(@z).each do |vehicle|
          @event_vehicles << vehicle.id
        end
      elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count < @g && @use_b_shock_service_near_2.all.count < @h && @use_b_shock_service.all.count < @i && @use_b_near_service_nas.all.count < @j && @use_b_air_filter_service_near_nas.all.count < @k && @use_b_a_service_near_1_nas.all.count < @l && @use_b_shock_service_near_1_nas.all.count < @m && @use_b_air_filter_service_nas.all.count < @n && @use_b_a_service_near_2_nas.all.count < @o && @use_b_a_service_nas.all.count < @p && @use_b_shock_service_near_2_nas.all.count < @q && @use_b_shock_service_nas.all.count < @r && @use_b_near_service_nss.all.count < @s && @use_b_air_filter_service_near_nss.all.count < @t && @use_b_a_service_near_1_nss.all.count < @u && @use_b_shock_service_near_1_nss.all.count < @v && @use_b_air_filter_service_nss.all.count < @w && @use_b_a_service_near_2_nss.all.count < @x && @use_b_a_service_nss.all.count < @y && @use_b_shock_service_near_2_nss.all.count < @z && @use_b_shock_service_nss.all.count >= @ab

        @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
          @event_vehicles << vehicle.id
        end

        @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2.order(times_used: :asc).limit(@h).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service.order(times_used: :asc).limit(@i).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_near_service_nas.order(times_used: :asc).limit(@j).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near_nas.order(times_used: :asc).limit(@k).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1_nas.order(times_used: :asc).limit(@l).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1_nas.order(times_used: :asc).limit(@m).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_nas.order(times_used: :asc).limit(@n).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2_nas.order(times_used: :asc).limit(@o).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_nas.order(times_used: :asc).limit(@p).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2_nas.order(times_used: :asc).limit(@q).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_nas.order(times_used: :asc).limit(@r).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_near_service_nss.order(times_used: :asc).limit(@s).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near_nss.order(times_used: :asc).limit(@t).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1_nss.order(times_used: :asc).limit(@u).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1_nss.order(times_used: :asc).limit(@v).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_nss.order(times_used: :asc).limit(@w).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2_nss.order(times_used: :asc).limit(@x).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_nss.order(times_used: :asc).limit(@y).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2_nss.order(times_used: :asc).limit(@z).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_nss.order(times_used: :asc).limit(@aa).each do |vehicle|
          @event_vehicles << vehicle.id
        end
      elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count < @g && @use_b_shock_service_near_2.all.count < @h && @use_b_shock_service.all.count < @i && @use_b_near_service_nas.all.count < @j && @use_b_air_filter_service_near_nas.all.count < @k && @use_b_a_service_near_1_nas.all.count < @l && @use_b_shock_service_near_1_nas.all.count < @m && @use_b_air_filter_service_nas.all.count < @n && @use_b_a_service_near_2_nas.all.count < @o && @use_b_a_service_nas.all.count < @p && @use_b_shock_service_near_2_nas.all.count < @q && @use_b_shock_service_nas.all.count < @r && @use_b_near_service_nss.all.count < @s && @use_b_air_filter_service_near_nss.all.count < @t && @use_b_a_service_near_1_nss.all.count < @u && @use_b_shock_service_near_1_nss.all.count < @v && @use_b_air_filter_service_nss.all.count < @w && @use_b_a_service_near_2_nss.all.count < @x && @use_b_a_service_nss.all.count < @y && @use_b_shock_service_near_2_nss.all.count < @z && @use_b_shock_service_nss.all.count < @aa && @use_b_near_service_nass.all.count >= @ab

        @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
          @event_vehicles << vehicle.id
        end

        @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2.order(times_used: :asc).limit(@h).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service.order(times_used: :asc).limit(@i).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_near_service_nas.order(times_used: :asc).limit(@j).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near_nas.order(times_used: :asc).limit(@k).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1_nas.order(times_used: :asc).limit(@l).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1_nas.order(times_used: :asc).limit(@m).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_nas.order(times_used: :asc).limit(@n).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2_nas.order(times_used: :asc).limit(@o).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_nas.order(times_used: :asc).limit(@p).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2_nas.order(times_used: :asc).limit(@q).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_nas.order(times_used: :asc).limit(@r).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_near_service_nss.order(times_used: :asc).limit(@s).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near_nss.order(times_used: :asc).limit(@t).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1_nss.order(times_used: :asc).limit(@u).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1_nss.order(times_used: :asc).limit(@v).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_nss.order(times_used: :asc).limit(@w).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2_nss.order(times_used: :asc).limit(@x).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_nss.order(times_used: :asc).limit(@y).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2_nss.order(times_used: :asc).limit(@z).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_nss.order(times_used: :asc).limit(@aa).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_near_service_nass.order(times_used: :asc).limit(@ab).each do |vehicle|
          @event_vehicles << vehicle.id
        end
      elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count < @g && @use_b_shock_service_near_2.all.count < @h && @use_b_shock_service.all.count < @i && @use_b_near_service_nas.all.count < @j && @use_b_air_filter_service_near_nas.all.count < @k && @use_b_a_service_near_1_nas.all.count < @l && @use_b_shock_service_near_1_nas.all.count < @m && @use_b_air_filter_service_nas.all.count < @n && @use_b_a_service_near_2_nas.all.count < @o && @use_b_a_service_nas.all.count < @p && @use_b_shock_service_near_2_nas.all.count < @q && @use_b_shock_service_nas.all.count < @r && @use_b_near_service_nss.all.count < @s && @use_b_air_filter_service_near_nss.all.count < @t && @use_b_a_service_near_1_nss.all.count < @u && @use_b_shock_service_near_1_nss.all.count < @v && @use_b_air_filter_service_nss.all.count < @w && @use_b_a_service_near_2_nss.all.count < @x && @use_b_a_service_nss.all.count < @y && @use_b_shock_service_near_2_nss.all.count < @z && @use_b_shock_service_nss.all.count < @aa && @use_b_near_service_nass.all.count < @ab && @use_b_air_filter_service_near_nass.all.count >= @ac

        @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
          @event_vehicles << vehicle.id
        end

        @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2.order(times_used: :asc).limit(@h).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service.order(times_used: :asc).limit(@i).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_near_service_nas.order(times_used: :asc).limit(@j).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near_nas.order(times_used: :asc).limit(@k).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1_nas.order(times_used: :asc).limit(@l).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1_nas.order(times_used: :asc).limit(@m).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_nas.order(times_used: :asc).limit(@n).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2_nas.order(times_used: :asc).limit(@o).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_nas.order(times_used: :asc).limit(@p).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2_nas.order(times_used: :asc).limit(@q).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_nas.order(times_used: :asc).limit(@r).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_near_service_nss.order(times_used: :asc).limit(@s).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near_nss.order(times_used: :asc).limit(@t).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1_nss.order(times_used: :asc).limit(@u).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1_nss.order(times_used: :asc).limit(@v).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_nss.order(times_used: :asc).limit(@w).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2_nss.order(times_used: :asc).limit(@x).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_nss.order(times_used: :asc).limit(@y).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2_nss.order(times_used: :asc).limit(@z).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_nss.order(times_used: :asc).limit(@aa).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_near_service_nass.order(times_used: :asc).limit(@ab).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near_nass.order(times_used: :asc).limit(@ac).each do |vehicle|
          @event_vehicles << vehicle.id
        end
      elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count < @g && @use_b_shock_service_near_2.all.count < @h && @use_b_shock_service.all.count < @i && @use_b_near_service_nas.all.count < @j && @use_b_air_filter_service_near_nas.all.count < @k && @use_b_a_service_near_1_nas.all.count < @l && @use_b_shock_service_near_1_nas.all.count < @m && @use_b_air_filter_service_nas.all.count < @n && @use_b_a_service_near_2_nas.all.count < @o && @use_b_a_service_nas.all.count < @p && @use_b_shock_service_near_2_nas.all.count < @q && @use_b_shock_service_nas.all.count < @r && @use_b_near_service_nss.all.count < @s && @use_b_air_filter_service_near_nss.all.count < @t && @use_b_a_service_near_1_nss.all.count < @u && @use_b_shock_service_near_1_nss.all.count < @v && @use_b_air_filter_service_nss.all.count < @w && @use_b_a_service_near_2_nss.all.count < @x && @use_b_a_service_nss.all.count < @y && @use_b_shock_service_near_2_nss.all.count < @z && @use_b_shock_service_nss.all.count < @aa && @use_b_near_service_nass.all.count < @ab && @use_b_air_filter_service_near_nass.all.count < @ac && @use_b_a_service_near_1_nass.all.count >= @ad

        @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
          @event_vehicles << vehicle.id
        end

        @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2.order(times_used: :asc).limit(@h).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service.order(times_used: :asc).limit(@i).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_near_service_nas.order(times_used: :asc).limit(@j).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near_nas.order(times_used: :asc).limit(@k).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1_nas.order(times_used: :asc).limit(@l).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1_nas.order(times_used: :asc).limit(@m).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_nas.order(times_used: :asc).limit(@n).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2_nas.order(times_used: :asc).limit(@o).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_nas.order(times_used: :asc).limit(@p).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2_nas.order(times_used: :asc).limit(@q).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_nas.order(times_used: :asc).limit(@r).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_near_service_nss.order(times_used: :asc).limit(@s).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near_nss.order(times_used: :asc).limit(@t).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1_nss.order(times_used: :asc).limit(@u).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1_nss.order(times_used: :asc).limit(@v).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_nss.order(times_used: :asc).limit(@w).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2_nss.order(times_used: :asc).limit(@x).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_nss.order(times_used: :asc).limit(@y).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2_nss.order(times_used: :asc).limit(@z).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_nss.order(times_used: :asc).limit(@aa).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_near_service_nass.order(times_used: :asc).limit(@ab).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near_nass.order(times_used: :asc).limit(@ac).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1_nass.order(times_used: :asc).limit(@ad).each do |vehicle|
          @event_vehicles << vehicle.id
        end

      elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count < @g && @use_b_shock_service_near_2.all.count < @h && @use_b_shock_service.all.count < @i && @use_b_near_service_nas.all.count < @j && @use_b_air_filter_service_near_nas.all.count < @k && @use_b_a_service_near_1_nas.all.count < @l && @use_b_shock_service_near_1_nas.all.count < @m && @use_b_air_filter_service_nas.all.count < @n && @use_b_a_service_near_2_nas.all.count < @o && @use_b_a_service_nas.all.count < @p && @use_b_shock_service_near_2_nas.all.count < @q && @use_b_shock_service_nas.all.count < @r && @use_b_near_service_nss.all.count < @s && @use_b_air_filter_service_near_nss.all.count < @t && @use_b_a_service_near_1_nss.all.count < @u && @use_b_shock_service_near_1_nss.all.count < @v && @use_b_air_filter_service_nss.all.count < @w && @use_b_a_service_near_2_nss.all.count < @x && @use_b_a_service_nss.all.count < @y && @use_b_shock_service_near_2_nss.all.count < @z && @use_b_shock_service_nss.all.count < @aa && @use_b_near_service_nass.all.count < @ab && @use_b_air_filter_service_near_nass.all.count < @ac && @use_b_a_service_near_1_nass.all.count < @ad && @use_b_shock_service_near_1_nass.all.count >= @ae

        @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
          @event_vehicles << vehicle.id
        end

        @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2.order(times_used: :asc).limit(@h).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service.order(times_used: :asc).limit(@i).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_near_service_nas.order(times_used: :asc).limit(@j).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near_nas.order(times_used: :asc).limit(@k).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1_nas.order(times_used: :asc).limit(@l).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1_nas.order(times_used: :asc).limit(@m).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_nas.order(times_used: :asc).limit(@n).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2_nas.order(times_used: :asc).limit(@o).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_nas.order(times_used: :asc).limit(@p).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2_nas.order(times_used: :asc).limit(@q).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_nas.order(times_used: :asc).limit(@r).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_near_service_nss.order(times_used: :asc).limit(@s).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near_nss.order(times_used: :asc).limit(@t).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1_nss.order(times_used: :asc).limit(@u).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1_nss.order(times_used: :asc).limit(@v).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_nss.order(times_used: :asc).limit(@w).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2_nss.order(times_used: :asc).limit(@x).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_nss.order(times_used: :asc).limit(@y).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2_nss.order(times_used: :asc).limit(@z).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_nss.order(times_used: :asc).limit(@aa).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_near_service_nass.order(times_used: :asc).limit(@ab).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near_nass.order(times_used: :asc).limit(@ac).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1_nass.order(times_used: :asc).limit(@ad).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1_nass.order(times_used: :asc).limit(@ae).each do |vehicle|
          @event_vehicles << vehicle.id
        end
      elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count < @g && @use_b_shock_service_near_2.all.count < @h && @use_b_shock_service.all.count < @i && @use_b_near_service_nas.all.count < @j && @use_b_air_filter_service_near_nas.all.count < @k && @use_b_a_service_near_1_nas.all.count < @l && @use_b_shock_service_near_1_nas.all.count < @m && @use_b_air_filter_service_nas.all.count < @n && @use_b_a_service_near_2_nas.all.count < @o && @use_b_a_service_nas.all.count < @p && @use_b_shock_service_near_2_nas.all.count < @q && @use_b_shock_service_nas.all.count < @r && @use_b_near_service_nss.all.count < @s && @use_b_air_filter_service_near_nss.all.count < @t && @use_b_a_service_near_1_nss.all.count < @u && @use_b_shock_service_near_1_nss.all.count < @v && @use_b_air_filter_service_nss.all.count < @w && @use_b_a_service_near_2_nss.all.count < @x && @use_b_a_service_nss.all.count < @y && @use_b_shock_service_near_2_nss.all.count < @z && @use_b_shock_service_nss.all.count < @aa && @use_b_near_service_nass.all.count < @ab && @use_b_air_filter_service_near_nass.all.count < @ac && @use_b_a_service_near_1_nass.all.count < @ad && @use_b_shock_service_near_1_nass.all.count < @ae && @use_b_air_filter_service_nass.all.count >= @af

        @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
          @event_vehicles << vehicle.id
        end

        @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2.order(times_used: :asc).limit(@h).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service.order(times_used: :asc).limit(@i).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_near_service_nas.order(times_used: :asc).limit(@j).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near_nas.order(times_used: :asc).limit(@k).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1_nas.order(times_used: :asc).limit(@l).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1_nas.order(times_used: :asc).limit(@m).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_nas.order(times_used: :asc).limit(@n).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2_nas.order(times_used: :asc).limit(@o).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_nas.order(times_used: :asc).limit(@p).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2_nas.order(times_used: :asc).limit(@q).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_nas.order(times_used: :asc).limit(@r).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_near_service_nss.order(times_used: :asc).limit(@s).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near_nss.order(times_used: :asc).limit(@t).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1_nss.order(times_used: :asc).limit(@u).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1_nss.order(times_used: :asc).limit(@v).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_nss.order(times_used: :asc).limit(@w).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2_nss.order(times_used: :asc).limit(@x).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_nss.order(times_used: :asc).limit(@y).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2_nss.order(times_used: :asc).limit(@z).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_nss.order(times_used: :asc).limit(@aa).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_near_service_nass.order(times_used: :asc).limit(@ab).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near_nass.order(times_used: :asc).limit(@ac).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1_nass.order(times_used: :asc).limit(@ad).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1_nass.order(times_used: :asc).limit(@ae).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_nass.order(times_used: :asc).limit(@af).each do |vehicle|
          @event_vehicles << vehicle.id
        end
      elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count < @g && @use_b_shock_service_near_2.all.count < @h && @use_b_shock_service.all.count < @i && @use_b_near_service_nas.all.count < @j && @use_b_air_filter_service_near_nas.all.count < @k && @use_b_a_service_near_1_nas.all.count < @l && @use_b_shock_service_near_1_nas.all.count < @m && @use_b_air_filter_service_nas.all.count < @n && @use_b_a_service_near_2_nas.all.count < @o && @use_b_a_service_nas.all.count < @p && @use_b_shock_service_near_2_nas.all.count < @q && @use_b_shock_service_nas.all.count < @r && @use_b_near_service_nss.all.count < @s && @use_b_air_filter_service_near_nss.all.count < @t && @use_b_a_service_near_1_nss.all.count < @u && @use_b_shock_service_near_1_nss.all.count < @v && @use_b_air_filter_service_nss.all.count < @w && @use_b_a_service_near_2_nss.all.count < @x && @use_b_a_service_nss.all.count < @y && @use_b_shock_service_near_2_nss.all.count < @z && @use_b_shock_service_nss.all.count < @aa && @use_b_near_service_nass.all.count < @ab && @use_b_air_filter_service_near_nass.all.count < @ac && @use_b_a_service_near_1_nass.all.count < @ad && @use_b_shock_service_near_1_nass.all.count < @ae && @use_b_air_filter_service_nass.all.count < @af && @use_b_a_service_near_2_nass.all.count >= @ag

        @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
          @event_vehicles << vehicle.id
        end

        @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2.order(times_used: :asc).limit(@h).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service.order(times_used: :asc).limit(@i).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_near_service_nas.order(times_used: :asc).limit(@j).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near_nas.order(times_used: :asc).limit(@k).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1_nas.order(times_used: :asc).limit(@l).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1_nas.order(times_used: :asc).limit(@m).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_nas.order(times_used: :asc).limit(@n).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2_nas.order(times_used: :asc).limit(@o).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_nas.order(times_used: :asc).limit(@p).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2_nas.order(times_used: :asc).limit(@q).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_nas.order(times_used: :asc).limit(@r).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_near_service_nss.order(times_used: :asc).limit(@s).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near_nss.order(times_used: :asc).limit(@t).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1_nss.order(times_used: :asc).limit(@u).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1_nss.order(times_used: :asc).limit(@v).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_nss.order(times_used: :asc).limit(@w).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2_nss.order(times_used: :asc).limit(@x).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_nss.order(times_used: :asc).limit(@y).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2_nss.order(times_used: :asc).limit(@z).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_nss.order(times_used: :asc).limit(@aa).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_near_service_nass.order(times_used: :asc).limit(@ab).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near_nass.order(times_used: :asc).limit(@ac).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1_nass.order(times_used: :asc).limit(@ad).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1_nass.order(times_used: :asc).limit(@ae).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_nass.order(times_used: :asc).limit(@af).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2_nass.order(times_used: :asc).limit(@ag).each do |vehicle|
          @event_vehicles << vehicle.id
        end
      elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count < @g && @use_b_shock_service_near_2.all.count < @h && @use_b_shock_service.all.count < @i && @use_b_near_service_nas.all.count < @j && @use_b_air_filter_service_near_nas.all.count < @k && @use_b_a_service_near_1_nas.all.count < @l && @use_b_shock_service_near_1_nas.all.count < @m && @use_b_air_filter_service_nas.all.count < @n && @use_b_a_service_near_2_nas.all.count < @o && @use_b_a_service_nas.all.count < @p && @use_b_shock_service_near_2_nas.all.count < @q && @use_b_shock_service_nas.all.count < @r && @use_b_near_service_nss.all.count < @s && @use_b_air_filter_service_near_nss.all.count < @t && @use_b_a_service_near_1_nss.all.count < @u && @use_b_shock_service_near_1_nss.all.count < @v && @use_b_air_filter_service_nss.all.count < @w && @use_b_a_service_near_2_nss.all.count < @x && @use_b_a_service_nss.all.count < @y && @use_b_shock_service_near_2_nss.all.count < @z && @use_b_shock_service_nss.all.count < @aa && @use_b_near_service_nass.all.count < @ab && @use_b_air_filter_service_near_nass.all.count < @ac && @use_b_a_service_near_1_nass.all.count < @ad && @use_b_shock_service_near_1_nass.all.count < @ae && @use_b_air_filter_service_nass.all.count < @af && @use_b_a_service_near_2_nass.all.count < @ag && @use_b_a_service_nass.all.count >= @ah

        @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
          @event_vehicles << vehicle.id
        end

        @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2.order(times_used: :asc).limit(@h).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service.order(times_used: :asc).limit(@i).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_near_service_nas.order(times_used: :asc).limit(@j).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near_nas.order(times_used: :asc).limit(@k).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1_nas.order(times_used: :asc).limit(@l).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1_nas.order(times_used: :asc).limit(@m).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_nas.order(times_used: :asc).limit(@n).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2_nas.order(times_used: :asc).limit(@o).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_nas.order(times_used: :asc).limit(@p).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2_nas.order(times_used: :asc).limit(@q).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_nas.order(times_used: :asc).limit(@r).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_near_service_nss.order(times_used: :asc).limit(@s).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near_nss.order(times_used: :asc).limit(@t).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1_nss.order(times_used: :asc).limit(@u).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1_nss.order(times_used: :asc).limit(@v).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_nss.order(times_used: :asc).limit(@w).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2_nss.order(times_used: :asc).limit(@x).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_nss.order(times_used: :asc).limit(@y).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2_nss.order(times_used: :asc).limit(@z).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_nss.order(times_used: :asc).limit(@aa).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_near_service_nass.order(times_used: :asc).limit(@ab).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near_nass.order(times_used: :asc).limit(@ac).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1_nass.order(times_used: :asc).limit(@ad).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1_nass.order(times_used: :asc).limit(@ae).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_nass.order(times_used: :asc).limit(@af).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2_nass.order(times_used: :asc).limit(@ag).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_nass.order(times_used: :asc).limit(@ah).each do |vehicle|
          @event_vehicles << vehicle.id
        end
      elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count < @g && @use_b_shock_service_near_2.all.count < @h && @use_b_shock_service.all.count < @i && @use_b_near_service_nas.all.count < @j && @use_b_air_filter_service_near_nas.all.count < @k && @use_b_a_service_near_1_nas.all.count < @l && @use_b_shock_service_near_1_nas.all.count < @m && @use_b_air_filter_service_nas.all.count < @n && @use_b_a_service_near_2_nas.all.count < @o && @use_b_a_service_nas.all.count < @p && @use_b_shock_service_near_2_nas.all.count < @q && @use_b_shock_service_nas.all.count < @r && @use_b_near_service_nss.all.count < @s && @use_b_air_filter_service_near_nss.all.count < @t && @use_b_a_service_near_1_nss.all.count < @u && @use_b_shock_service_near_1_nss.all.count < @v && @use_b_air_filter_service_nss.all.count < @w && @use_b_a_service_near_2_nss.all.count < @x && @use_b_a_service_nss.all.count < @y && @use_b_shock_service_near_2_nss.all.count < @z && @use_b_shock_service_nss.all.count < @aa && @use_b_near_service_nass.all.count < @ab && @use_b_air_filter_service_near_nass.all.count < @ac && @use_b_a_service_near_1_nass.all.count < @ad && @use_b_shock_service_near_1_nass.all.count < @ae && @use_b_air_filter_service_nass.all.count < @af && @use_b_a_service_near_2_nass.all.count < @ag && @use_b_a_service_nass.all.count < @ah && @use_b_shock_service_near_2_nass.all.count >= @ai

        @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
          @event_vehicles << vehicle.id
        end

        @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2.order(times_used: :asc).limit(@h).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service.order(times_used: :asc).limit(@i).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_near_service_nas.order(times_used: :asc).limit(@j).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near_nas.order(times_used: :asc).limit(@k).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1_nas.order(times_used: :asc).limit(@l).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1_nas.order(times_used: :asc).limit(@m).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_nas.order(times_used: :asc).limit(@n).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2_nas.order(times_used: :asc).limit(@o).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_nas.order(times_used: :asc).limit(@p).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2_nas.order(times_used: :asc).limit(@q).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_nas.order(times_used: :asc).limit(@r).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_near_service_nss.order(times_used: :asc).limit(@s).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near_nss.order(times_used: :asc).limit(@t).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1_nss.order(times_used: :asc).limit(@u).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1_nss.order(times_used: :asc).limit(@v).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_nss.order(times_used: :asc).limit(@w).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2_nss.order(times_used: :asc).limit(@x).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_nss.order(times_used: :asc).limit(@y).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2_nss.order(times_used: :asc).limit(@z).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_nss.order(times_used: :asc).limit(@aa).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_near_service_nass.order(times_used: :asc).limit(@ab).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near_nass.order(times_used: :asc).limit(@ac).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1_nass.order(times_used: :asc).limit(@ad).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1_nass.order(times_used: :asc).limit(@ae).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_nass.order(times_used: :asc).limit(@af).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2_nass.order(times_used: :asc).limit(@ag).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_nass.order(times_used: :asc).limit(@ah).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2_nass.order(times_used: :asc).limit(@ai).each do |vehicle|
          @event_vehicles << vehicle.id
        end
      elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count < @g && @use_b_shock_service_near_2.all.count < @h && @use_b_shock_service.all.count < @i && @use_b_near_service_nas.all.count < @j && @use_b_air_filter_service_near_nas.all.count < @k && @use_b_a_service_near_1_nas.all.count < @l && @use_b_shock_service_near_1_nas.all.count < @m && @use_b_air_filter_service_nas.all.count < @n && @use_b_a_service_near_2_nas.all.count < @o && @use_b_a_service_nas.all.count < @p && @use_b_shock_service_near_2_nas.all.count < @q && @use_b_shock_service_nas.all.count < @r && @use_b_near_service_nss.all.count < @s && @use_b_air_filter_service_near_nss.all.count < @t && @use_b_a_service_near_1_nss.all.count < @u && @use_b_shock_service_near_1_nss.all.count < @v && @use_b_air_filter_service_nss.all.count < @w && @use_b_a_service_near_2_nss.all.count < @x && @use_b_a_service_nss.all.count < @y && @use_b_shock_service_near_2_nss.all.count < @z && @use_b_shock_service_nss.all.count < @aa && @use_b_near_service_nass.all.count < @ab && @use_b_air_filter_service_near_nass.all.count < @ac && @use_b_a_service_near_1_nass.all.count < @ad && @use_b_shock_service_near_1_nass.all.count < @ae && @use_b_air_filter_service_nass.all.count < @af && @use_b_a_service_near_2_nass.all.count < @ag && @use_b_a_service_nass.all.count < @ah && @use_b_shock_service_near_2_nass.all.count < @ai && @use_b_shock_service_nass.all.count >= @aj

        @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
          @event_vehicles << vehicle.id
        end

        @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2.order(times_used: :asc).limit(@h).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service.order(times_used: :asc).limit(@i).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_near_service_nas.order(times_used: :asc).limit(@j).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near_nas.order(times_used: :asc).limit(@k).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1_nas.order(times_used: :asc).limit(@l).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1_nas.order(times_used: :asc).limit(@m).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_nas.order(times_used: :asc).limit(@n).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2_nas.order(times_used: :asc).limit(@o).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_nas.order(times_used: :asc).limit(@p).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2_nas.order(times_used: :asc).limit(@q).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_nas.order(times_used: :asc).limit(@r).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_near_service_nss.order(times_used: :asc).limit(@s).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near_nss.order(times_used: :asc).limit(@t).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1_nss.order(times_used: :asc).limit(@u).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1_nss.order(times_used: :asc).limit(@v).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_nss.order(times_used: :asc).limit(@w).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2_nss.order(times_used: :asc).limit(@x).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_nss.order(times_used: :asc).limit(@y).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2_nss.order(times_used: :asc).limit(@z).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_nss.order(times_used: :asc).limit(@aa).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_near_service_nass.order(times_used: :asc).limit(@ab).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_near_nass.order(times_used: :asc).limit(@ac).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_1_nass.order(times_used: :asc).limit(@ad).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_1_nass.order(times_used: :asc).limit(@ae).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_air_filter_service_nass.order(times_used: :asc).limit(@af).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_near_2_nass.order(times_used: :asc).limit(@ag).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_a_service_nass.order(times_used: :asc).limit(@ah).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_near_2_nass.order(times_used: :asc).limit(@ai).each do |vehicle|
          @event_vehicles << vehicle.id
        end
        @use_b_shock_service_nass.order(times_used: :asc).limit(@aj).each do |vehicle|
          @event_vehicles << vehicle.id
        end

      else
        @event.update(vehicle_ids: [])
    end
      @event.update(vehicle_ids: @event_vehicles)

      if @event.vehicles == []
        flash[:alert] = 'Insufficient number of vehicles at current location. Please move vehicles to this location or maunally select vehicles.'
      else
        flash[:notice] = 'Vehicles successfully added!'
      end
      redirect_back(fallback_location: root_path)
  end
end
end
