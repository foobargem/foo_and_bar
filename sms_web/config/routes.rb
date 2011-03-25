SmsWeb::Application.routes.draw do

  devise_for :admins,
    :path => "admin",
    :controllers => {
      :sessions => "admin/sessions"
    }
 

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)
  match "flickr_auth/new" => "flickr_auth#new", :as => :flickr_auth
  match "flickr_auth/callback" => "flickr_auth#callback", :as => :flickr_callback

  match "tracking/impr" => "banner_logs#impression", :as => :impression_tracking
  match "tracking/click" => "banner_logs#click", :as => :click_tracking

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products
  resources :events do
    resources :applicants
  end

  resources :companies
  resources :cars do 
    collection do 
      get "photos"
      get "booth"
    end
  end
  
  resources :racing_models do
    member do
      get "photos"
    end
  end
  resources :videos
  resources :photos do
    collection do
      get "models_by_company"
      get "by_company_booth_code"
    end
  end
  resources :banners do
    collection do
      get "base_ad"
    end
  end

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
  namespace :admin do
    resources :companies do
      member do
        get "upload_to_flickr"
      end
      collection do
        put "batch_upload_to_flickr"
      end
    end
    resources :cars do
      member do
        get "upload_to_flickr"
      end
      collection do
        put "batch_upload_to_flickr"
        get "export_to_excel"
      end
    end

    resources :racing_models do
      member do
        get "upload_to_flickr"
      end
      collection do
        put "batch_upload_to_flickr"
      end
    end

    resources :photos do
      member do
        get "upload_to_flickr"
      end
      collection do
        put "batch_upload_to_flickr"
      end
    end

    resources :videos
    resources :banners
    resources :events do
      resources :applicants do
        collection do
          get "export_to_excel"
        end
      end
    end
  end
  match "/admin" => "admin/companies#index", :as => :admin_root

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => "events#index"

  # See how all your routes lay out with "rake routes"

 # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
