ConsoleRails::Application.routes.draw do

  devise_for :users, :controllers => {
    :omniauth_callbacks => "users/omniauth_callbacks",
    :invitations => 'users/invitations'
  }

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'console#index'

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

  get 'login' => 'login#index'
  get 'login/google' => 'login#google'
  get 'login/google_callback' => 'login#google_callback'
  get 'logout' => 'login#logout'
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
