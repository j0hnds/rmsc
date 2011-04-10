Rmsc::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  resources :attendances do
    get :unregistered_buyers, :on => :collection
    get :non_attending_buyers, :on => :collection
    post :register_buyers, :on => :collection
  end

  resources :booklets 

  resources :buyers do
    post :search, :on => :collection
  end

  resources :coordinators do
    post :search, :on => :collection
  end

  resources :exhibitors do
    post :search, :on => :collection
  end

  resources :registrations do
    post :room, :on => :collection
    post :lines, :on => :collection
    post :associates, :on => :collection
    get :unregistered_exhibitors, :on => :collection
    post :register_exhibitors, :on => :collection
    post :add_room, :on => :member
    post :delete_room, :on => :member
  end

  resources :shows do
    post :search, :on => :collection
    post :set_current_show, :on => :collection
  end

  resources :stores do
    post :search, :on => :collection
  end

  resources :store_mailing_labels do
    post :print, :on => :collection
  end

  resources :venues do
    post :search, :on => :collection
  end

  root :to => "dashboard#index"

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
