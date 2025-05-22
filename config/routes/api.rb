namespace :api, format: :json do
  resources :companies
  resources :users do
    collection do
      post :me
      post :current
      post :refresh
    end
  end
end
