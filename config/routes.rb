Rails.application.routes.draw do

  # ---------------------- TESTING --------------------------------------------------
  # TODO: move this routes to some scope (inside users resources / pets resources). don't add routes with no context
  get 'users/all' => 'users#all'

  get 'pets/all' => 'pets#showAllPets'
  # ---------------------------------------------------------------------------------

  scope format: false do
    resources :users, param: :user_id, only: [:index, :show] do
      member do
        resources :pets, only: [:index]
        resources :reviews, only: [:index, :create]
      end

      collection do
        resources :pets, param: :pet_id, only: [:index, :create, :update] do
          collection do 
            post :upload_image
          end
        end
        resources :reviews, only: [] do
          get :index, action: :my_reviews, on: :collection # reviews written by user
        end
      end
    end

    resources :services, param: :service_id, except: [:new, :edit, :show] do
        member do
          get :requests
          post :requests, action: :add_request # for adding a request to a service provider
          post :add_location
          get :locations
          get :service_providers_for_service # a list of available service providers (return all for now)

          put :approve
          put :deny

          put :choose_service_provider

          delete :cancel
        end
    end

    resources :races, only: [:index, :create]

    resources :auth, only: [] do 
      collection do 
        post :login
        post :signup
        get :is_email_exist
      end
    end
  end

  match "*path", to: "auth#catch_error", via: :all
  
end
