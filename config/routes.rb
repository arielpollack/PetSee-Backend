Rails.application.routes.draw do

  resources :users do
    member do
      resources :pets, only: [:index]
      resources :reviews, only: [:index, :create]
    end

    collection do
      resources :pets, only: [:index, :create, :update]
      resources :reviews do
        get :my_reviews, on: :collection # reviews written by user
      end
    end
  end

  resources :races, only: [:index, :create]

  resources :auth do 
    collection do 
      post :login
      post :signup
      get :is_email_exist
    end
  end
  
end
