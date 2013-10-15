require 'resque/server'

Mechanio::Application.routes.draw do

  devise_for :admin
  devise_for :mechanics
  devise_for :users

  mount Resque::Server.new, at: '/resque'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'

  namespace :users do
    get 'dashboard', to: 'dashboard#index'
    get 'estimates', to: 'estimates#index'

    resources :jobs, only: [:show, :create]
    resource :profile, only: [:show, :edit, :update]
  end
  get '/service', to: 'users/jobs#new'

  namespace :mechanics do
    get '/', to: 'dashboard#index', as: :dashboard
    resource :profile, only: [:show, :edit, :update]
    resources :jobs, only: [:edit]
  end

  namespace :admin do
    get '/', to: 'dashboard#index', as: :dashboard

    resources :users
    resources :mechanics, except: [:show]
    resources :model_variations, only: [:index]
    resources :service_plans, except: [:index, :show] do
      collection do
        get 'default', action: 'index_default'
        get 'by_model', action: 'index_by_model'
      end
    end
    resources :jobs, only: [:index, :edit, :update]
  end

  resource :ajax, controller: 'ajax', only: [] do
    get 'models'
    get 'model_variations'
    get 'service_plans'
  end

  get '/static/:action', controller: 'static'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
