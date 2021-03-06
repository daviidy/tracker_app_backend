Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'registrations'}
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'home#index'
  resources :habits do
    resources :measurements
  end
  post :auth, to: 'authentication#create'
  get  '/auth' => 'authentication#fetch'
  get  '/measures' => 'measurements#index'
end
