Rails.application.routes.draw do
  root 'currencies#latest'

  resources :currencies do
    collection do
      get  'latest'
      post 'publish'
    end
  end
end
