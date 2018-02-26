Rails.application.routes.draw do
  
  namespace "api" do
    resources :channels, only: [:show], defaults: {format: :json} do
      member do 
        get "raw"
      end
    end
  end
  
  resources :channels do
    resources :tweets 
    
    member do 
      get "rerun_query"
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  resources :tweets, only: [:show]
  
  root "channels#index"
end
