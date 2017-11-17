Rails.application.routes.draw do
  
  resources :programs
  get 'all_users' => 'show_users#all_users'
  get 'homepage' => 'welcome#homepage'
  resources :requests do
    collection do
      get 'a_service'
      get 'shock_service'
      get 'air_filter_service'
      get 'dashboard'
      get 'repairs'
    end
  end
  resources :events do
    collection do
     get 'dashboard' 
    end
  end
  resources :vehicles do
    collection do
      get 'in_service'
      get 'out_of_service'
      get 'all_vehicles'
      get 'needs_service'
      get 'near_service_required'
    end
  end
  devise_for :users, :controllers => { :registrations => "users/registrations" } do
    collection do
      get ':id/edit'
    end
  end

  
  root 'welcome#homepage'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
