# frozen_string_literal: true

Rails.application.routes.draw do
  post 'bookings' => 'web_hooks#receive', as: :receive_webhooks
  get 'web_hooks/view_bookings'
  # get 'json_test_page' => 'welcome#json_test_page'

  resource :calendar, only: [:show], controller: :calendar

  resources :checklists do
    collection do
      get 'records'
      get 'create_work_order'
    end
  end

  resources :defects do
    collection do
      get 'by_event'
      get 'create_defect_work_order'
      get 'create_manual_defect_work_order'
      get 'fixed'
      get 'report'
      get 'another'
    end
  end

  resources :reports do
    collection do
      get 'dashboard'
      get 'rzr_report'
      get 'defect_report'
      get 'work_order_in_progress_report'
      get 'work_order_completed_report'
      get 'work_order_defects_report'
      get 'weekly_work_order_reports'
      get 'weekly_vehicle_reports'
      get 'download'
      get 'generate_report'
      get 'tour_car_report'
      get 'other_vehicles_report'
      get 'work_order_report'
      get 'checklist_report'
      get 'work_orders_overdue'
      get 'vin_number_report'
    end
  end
  resources :parts do
    collection do
      get 'dashboard'
      get 'quant_none'
      get 'quant_low'
      get 'individual_financial_report'
      post :import
    end
  end

  resources :programs

  get 'all_users'             => 'users#all_users'
  post 'update_user'          => 'users#update_user'
  get 'dashboard'             => 'users#dashboard'
  get 'completed_work_orders' => 'users#completed_work_orders'
  get 'assigned_work_orders'  => 'users#assigned_work_orders'
  get 'manage_users'          => 'users#manage_users'
  get 'profile'               => 'users#profile'

  get 'homepage'              => 'welcome#homepage'
  
  resources :request_part_orders

  resources :requests do
    collection do
      get 'a_service'
      get 'shock_service'
      get 'air_filter_service'
      get 'dashboard'
      get 'repairs'
      get 'defects'
      get 'completed'
      get 'search'
      post 'add_to_request_part_order'
      get 'add_parts'
      get 'search_for_parts'
      get 'delete_parts'
      get 'in_progress'
      get 'remove_order_item'
      get 'overdue'
      get 'tour_car_prep'
      get 'new_requests'
      get 'create_work_order'
      get 'decision'
      get 'multi_vehicle'
      get 'edit_multi_vehicle'
    end
  end

  resources :events do
    collection do
      get 'dashboard'
      get 'completed_events'
      get 'scheduled_events'
      get 'json_data'
      get 'vehicle_rotation'
      get 'vehicles_assigned'
      get 'auto_select_vehicles'
      get 'next_month_calendar'
      get 'vehicle_rotation_metrics'
      post 'event_completed'
      get 'previous_month'
    end
  end
  resources :vehicles do
    collection do
      get 'in_service'
      get 'out_of_service'
      get 'all_vehicles'
      get 'needs_service'
      get 'near_service_required'
      get 'sold_vehicles'
      get 'vehicle_mileage'
      get 'defects_outstanding'
      get 'defects'
      post :import
    end
  end
  devise_for :users, controllers: { registrations: 'users/registrations' }
  root 'welcome#homepage'
end
