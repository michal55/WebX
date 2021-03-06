Rails.application.routes.draw do
  get 'debug' => 'debug#home'
  get 'export-api-instructions' => 'debug#api_export_instructions'
  get 'json_help' => 'debug#json_help', as: :json_help
  use_doorkeeper

  mount API::Root => '/'

  devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }, path: '', path_names: { sign_up: :join, sign_in: :login, sign_out: :logout }, module: :devise

  resources :users, only: [:index, :show, :update, :profile]
  get 'users/:id/profile' => 'users#profile', as: :profile
  post 'user/:id/profile/refresh-api-key' => 'users#refresh_api_key'


  resources :projects do
    resources :scripts do
      resources :frequencies
      resources :extractions do
        resources :extraction_datum
        get 'logs' => 'extraction_datum#logs'
        post 'logs' => 'extraction_datum#logs'
      end
      post 'run-now' => 'scripts#run_now'
    end
    resources :data_fields
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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

  root 'application#home'
end
