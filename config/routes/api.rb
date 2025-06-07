namespace :api, format: :json do
  resources :users do
    collection do
      post :me
      post :current
      post :refresh
    end
  end
  namespace :v1 do
    resources :posts
  end
end
