Rails.application.routes.draw do
  namespace :v1 do
    get   'assets/bgcolors',      to: 'assets#bgcolors'
    get   'assets/emotions',      to: 'assets#emotions'
    get   'assets/emotion-image', to: 'assets#emotion_image'

    scope :display do
      get   'main/mine', to: 'main#mine'
      get   'main/:id', to: 'main#show', :as => :main
    end

    get   'user-emotions/mine', to: 'user_emotions#mine'
    resources 'user-emotions', :controller => :user_emotions, :as => :user_emotions

    get   'homes/mine', to: 'homes#mine'
    patch 'homes/mine', to: 'homes#update_mine'
    resources :homes

    get   'users/me', to: 'users#me'
    patch 'users/me', to: 'users#update_me'
    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
    resources :users

    get   'files/prepare-upload', to: 'files#prepare_upload'
    resources :files, only: [:show], param: :filename
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
