Rails.application.routes.draw do

  get 'about', :as => '/about', to: 'home#about'
  root to: "home#index"   #home/index is /

  get 'courses/:id', to: 'courses#show', as: 'course'
  get 'courses', to: 'courses#index', :as => 'courses'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

end
