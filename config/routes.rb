Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index], module: :merchants
      end

      resources :items, only: [:index, :show, :destroy, :create, :update] do
        resources :merchant, only: [:index], controller: "items/merchants"
      end
    end
  end
end
