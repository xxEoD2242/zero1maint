Rails.application.routes.draw do
  
  resources :programs
  get 'all_users' => 'show_users#all_users'
  get 'homepage' => 'welcome#homepage'
  resources :requests
  resources :events
  resources :vehicles do
    collection do
      get 'in_service'
      get 'out_of_service'
      get 'all_vehicles'
    end
  end
  devise_for :users, :controllers => { :registrations => "users/registrations" }

  
  root 'welcome#homepage'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
