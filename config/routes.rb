Rails.application.routes.draw do

  get 'about', :as => '/about', to: 'pages#about'
  get 'privacy', :as => '/privacy', to: 'home#privacy'
  get 'accessibility', :as => '/accessibility', to: 'home#accessibility'
  root to: "home#index"   #home/index is /

  get 'courses/:lcc_code', to: 'courses#show', as: 'course'
  
  get 'courses', to: 'courses#index', :as => 'courses'

  get 'venues/:venue_id', to: 'courses#index', :as => 'venue'
  get 'providers/:provider_id', to: 'courses#index', :as => 'provider'
  get 'topics/:topic_id', to: 'courses#index', :as => 'topic'
  resources :stories, only: [:index, :show]
  resources :news, only: [:index, :show]

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

end
