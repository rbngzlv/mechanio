require 'resque/server'

Mechanio::Application.routes.draw do

  devise_for :admins
  devise_for :mechanics
  devise_for :users, controllers: {
    registrations: "users/registrations",
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  mount Resque::Server.new, at: '/resque'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root :to => 'pages#show', :id => 'home'

  get "/pages/*id" => 'pages#show', :as => :page, :format => false

  namespace :users do
    get 'dashboard', to: 'dashboard#index'
    get 'estimates', to: 'estimates#index'

    resources :jobs, only: [:show, :create] do
      resource :credit_card, only: [:new, :create]
    end
    resources :appointments, only: [:index, :edit, :update]
    resources :cars, only: [:index, :destroy]

    resource :profile, only: [:show, :edit, :update]
    resource :settings, only: [:edit, :update]
    resources :authentications, only: [:destroy]
  end
  get '/service', to: 'users/jobs#service'
  get '/repair',  to: 'users/jobs#repair'

  namespace :mechanics do
    get '/', to: 'dashboard#index', as: :dashboard

    resources :jobs, only: [:index, :show] do
      get :complete
      resource :car, only: [:update]
    end
    resources :events, only: [:index, :create, :destroy]

    resource :profile, only: [:show, :edit, :update]
    resource :settings, only: [:edit, :update]
  end

  namespace :admins do
    get '/', to: 'dashboard#index', as: :dashboard

    resources :users
    resources :mechanics, except: [:show] do
      get   :regions_subtree
      get   :edit_regions
      post  :update_regions
      patch :suspend
      patch :activate
    end
    resources :model_variations, only: [:index]
    resources :service_plans, except: [:index, :show] do
      collection do
        get 'default', action: 'index_default'
        get 'by_model', action: 'index_by_model'
      end
    end

    resources :jobs, only: [:index, :edit, :update, :destroy]
    resources :symptoms
  end

  resource :ajax, controller: 'ajax', only: [] do
    get 'models'
    get 'model_variations'
    get 'service_plans'
  end

  namespace :api, defaults: { format: :json } do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      namespace :mechanics do
        resources :jobs, only: [:index, :show]
      end
    end
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
  #     # Directs /admins/products/* to Admins::ProductsController
  #     # (app/controllers/admins/products_controller.rb)
  #     resources :products
  #   end
end
