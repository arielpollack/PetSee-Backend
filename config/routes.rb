Rails.application.routes.draw do

  scope format: false do
    resources :users, param: :user_id, only: [:index] do
      member do
        resources :pets, only: [:index]
        resources :reviews, only: [:index, :create]
      end

      collection do
        resources :pets, param: :pet_id, only: [:index, :create, :update]
        resources :reviews, only: [] do
          get :index, action: :my_reviews, on: :collection # reviews written by user
        end
      end
    end

    resources :services, param: :service_id, except: [:new, :edit, :show] do
        get :requests, on: :member
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
  
end
