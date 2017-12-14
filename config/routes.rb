Rails.application.routes.draw do

resource :calendar, only: [:show], controller: :calendar

 resources :checklists do
   collection do
     get 'records'
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
  get 'all_users' => 'show_users#all_users'
  get 'homepage' => 'welcome#homepage'
  get 'fare_harbor' => 'welcome#fare_harbor_data'
  resources :requests do
    collection do
      get 'a_service'
      get 'shock_service'
      get 'air_filter_service'
      get 'dashboard'
      get 'repairs'
      get 'defects'
      get 'completed_requests'
      get 'search'
      post 'add_to_request_part_order'
      get 'add_parts'
      get 'search_for_parts'
      get 'delete_parts'
      get 'in_progress'
      get 'remove_parts_from_request'
      get 'overdue'
      get 'new_requests'
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
    end
  end
  resources :vehicles do
    collection do
      get 'in_service'
      get 'out_of_service'
      get 'all_vehicles'
      get 'needs_service'
      get 'near_service_required'
      post :import
    end
  end
  devise_for :users, :controllers => { :registrations => "users/registrations" }
  root 'welcome#homepage'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
