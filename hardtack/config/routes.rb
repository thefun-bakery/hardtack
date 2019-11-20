Rails.application.routes.draw do
  #resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get   '/users/me', to: 'users#me'
  patch '/users/me', to: 'users#update_me'

  resources :users

  get '/404', to: 'errors#not_found'
  get '/500', to: 'errors#internal_server_error'
  
  namespace :auth do
    namespace :kakao do
      get 'oauth'
      get 'login'
    end
    get 'is-login'
    get 'logout'
  end
end
