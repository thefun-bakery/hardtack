Rails.application.routes.draw do
  namespace :v1 do
    get   'homes/mine', to: 'homes#mine'
    patch 'homes/mine', to: 'homes#update_mine'
    resources :homes

    get   'users/me', to: 'users#me'
    patch 'users/me', to: 'users#update_me'
    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
    resources :users

    resources :files, only: [:show, :new], param: :filename
  end

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
