Rails.application.routes.draw do

    # ---------------------- TESTING --------------------------------------------------
    # TODO: move this routes to some scope (inside users resources / pets resources). don't add routes with no context
    get 'users/all' => 'users#all'

    get 'pets/all' => 'pets#showAllPets'

    put 'users' => 'users#update'
    patch 'users' => 'users#update'

    get 'reviews/:user_id/' => 'reviews#review_about_user'
    # ---------------------------------------------------------------------------------

    scope format: false do
        resources :users, param: :user_id, only: [:index, :show] do
            member do
                resources :pets, only: [:index]
                resources :reviews, only: [:index, :create] do
                    get :review_about_user, on: :collection
                end
            end

            collection do
                put :device_token
                put :reset_badge_count

                resources :pets, param: :pet_id, only: [:index, :create, :update] do
                    collection do
                        post :upload_image
                    end
                end
                resources :reviews, only: [] do
                    get :index, action: :my_reviews, on: :collection # reviews written by user
                    put :update_existing_review, on: :collection
                end
            end
        end

        resources :services, param: :service_id, except: [:new, :edit, :show] do
            collection do
                get :my_requests
            end
            member do
                get :requests
                get :locations
                get :available_service_providers # a list of available service providers (return all for now)
                post :requests, action: :add_request # for adding a request to a service provider
                post :add_location
                put :approve
                put :deny
                put :start
                put :end
                put :choose_service_provider

                delete :cancel
            end
        end

        resources :races, only: [:index, :create]

        resources :notifications, param: :notification_id, only: [:index] do
            put :read, on: :member
            put :read_all, on: :collection
        end

        resources :auth, only: [] do
            collection do
                get :is_email_exist
                post :login
                post :signup
            end
        end

    end

    match "*path", to: "auth#catch_error", via: :all

end
