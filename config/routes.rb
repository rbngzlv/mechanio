require 'resque/server'

Mechanio::Application.routes.draw do

  devise_for :admins
  devise_for :mechanics
  devise_for :users, controllers: {
    registrations:      'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks',
    confirmations:      'users/confirmations'
  }

  mount Resque::Server.new, at: '/resque'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root :to => 'pages#show', :id => 'home'

  get "/pages/*id" => 'pages#show', :as => :page, :format => false

  namespace :users do
    get 'dashboard', to: 'dashboard#index'

    resources :jobs, only: [:show, :create] do
      resource :credit_card, only: [:new, :create]
      resource :discount, only: [:create]
    end
    resources :estimates, only: [:index] do
      delete :destroy, on: :collection
    end
    resources :appointments, only: [:index, :edit, :update, :show] do
      get :receipt, on: :member
      resource :rating, only: [:create]
    end
    resources :cars, only: [:index, :destroy]

    resource :profile, only: [:show, :edit, :update]
    resource :settings, only: [:edit, :update]
    resources :authentications, only: [:destroy]
    resources :invitations, only: [:index, :create]
  end
  get '/i/:referrer_code', to: 'users/invitations#detect', as: :referrer_users_invitations
  get '/service', to: 'users/jobs#service'
  get '/repair',  to: 'users/jobs#repair'

  namespace :mechanics do
    get '/', to: 'dashboard#index', as: :dashboard

    resources :jobs, only: [:index, :show] do
      get :complete
      resource :car, only: [:update]
    end
    resources :events, only: [:index, :create] do
      delete :destroy, on: :collection
    end
    resources :payouts, only: [] do
      get :receipt, on: :member
    end

    resource :profile, only: [:show, :edit, :update]
    resource :payout_method, only: [:edit, :update]
    resource :settings, only: [:edit, :update]
  end

  namespace :admins do
    get '/', to: 'dashboard#index', as: :dashboard

    resources :users, only: [:index, :show] do
      member do
        get :suspend
        get :activate
        get :impersonate
      end
      get :stop_impersonating, on: :collection
    end

    resources :mechanics, except: [:show] do
      patch :suspend
      patch :activate

      resource :regions, only: [:edit, :update], controller: 'mechanics/regions' do
        get :subtree
      end
      resource :payout_method, only: [:edit, :update], controller: 'mechanics/payout_methods'
      resources :jobs, only: [:index], controller: 'mechanics/jobs'
      resources :ratings, only: [:index, :edit], controller: 'mechanics/ratings'
    end
    resources :model_variations, only: [:index]
    resources :service_plans, except: [:index, :show] do
      collection do
        get 'default', action: 'index_default'
        get 'by_model', action: 'index_by_model'
      end
    end

    resources :jobs, only: [:index, :edit, :update, :destroy] do
      member do
        get :cancel
        get :complete
        get :select_mechanic
        patch :reassign
      end
    end
    resources :appointments, only: [:edit, :update]
    resources :payouts, only: [:create, :update] do
      get :receipt, on: :member
    end
    resources :symptoms
    resources :discounts
    resources :ratings, only: [:index, :edit, :update]
  end

  resource :ajax, controller: 'ajax', only: [] do
    get 'makes'
    get 'models'
    get 'model_variations'
    get 'service_plans'
    get 'suburbs'
  end

  namespace :api, defaults: { format: :json } do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      namespace :mechanics do
        resources :jobs, only: [:index, :show]
      end
    end
  end

  get '/static/:action', controller: 'static'

  if Rails.env.development?
    mount MailPreview => 'mail_view'
  end

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
