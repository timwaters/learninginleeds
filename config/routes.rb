Rails.application.routes.draw do

  get 'about', :as => '/about', to: 'pages#about'
  root to: "home#index"   #home/index is /

  get 'courses/:lcc_code', to: 'courses#show', as: 'course'
  
  get 'courses', to: 'courses#index', :as => 'courses'

  get 'venues/:venue_id', to: 'courses#index', :as => 'venue'
  get 'providers/:provider_id', to: 'courses#index', :as => 'provider'
  get 'topics/:topic_id', to: 'courses#index', :as => 'topic'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

end
