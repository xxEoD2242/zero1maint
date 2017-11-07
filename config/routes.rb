Rails.application.routes.draw do
  resources :requests
  
  get 'homepage' => 'welcome#homepage'

  devise_for :users
  
  root to: 'welcome#homepage'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
