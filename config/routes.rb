require 'sidekiq/web'
require 'sidetiq/web'

ConsoleRails::Application.routes.draw do

  devise_for :users, :controllers => {
    :omniauth_callbacks => "users/omniauth_callbacks",
    :invitations => 'users/invitations'
  }

  unauthenticated do
    root 'welcome#index'
  end

  authenticated :user do
    root 'boards#index', as: 'authenticated_root'
  end

  get "about" => 'welcome#about'
  get "team" => 'welcome#team'
  get "contact" => 'welcome#contact'
  post "contact" => 'welcome#message'
  get "blog" => 'welcome#blog'
  get "demo" => 'welcome#demo'
  get "features" => 'welcome#features'
  get "pricing" => 'welcome#pricing'
  get "terms" => 'welcome#terms'
  get "privacy" => 'welcome#privacy'
  post "newsletter" => 'welcome#newsletter'

  authenticate :user, lambda { |u| u.email == '11110000b@gmail.com' } do
    mount Sidekiq::Web => '/sidekiq'
  end

  resources :boards do
    resources :jobs do
      member do
        post 'duplicate' => 'jobs#duplicate'
      end
    end

    member do
      post 'public_id' => 'boards#reset_public_id'
    end
  end

  post 'sources/:id/tap' => 'sources#tap'

  get 'partials/:partial_id' => 'partials#show'

  namespace :integrations do
    get ':widget_id/config' => 'partials#configuration'
    get ':widget_id/html' => 'partials#html'
    get ':widget_id/js' => 'partials#js'
  end

  get 'dump' => 'dump#show'

  get '/:publicId' => 'public_boards#show', constraints: {subdomain: 'boards'}

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
