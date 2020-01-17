Rails.application.routes.draw do
  namespace :v1 do
    get   'assets/bgcolors',      to: 'assets#bgcolors'
    get   'assets/emotions',      to: 'assets#emotions'
    get   'assets/emotion-image', to: 'assets#emotion_image'

    scope :display do
      get   'main/mine', to: 'main#mine'
      get   'main/:home_id', to: 'main#show', :as => :main
    end

    get       'emotions/mine', to: 'emotions#mine'
    post      'emotions/:id/hug', to: 'emotions#hug', :as => :emotion_hug
    delete    'emotions/:id/hug', to: 'emotions#unhug', :as => :emotion_unhug
    resources 'emotions'

    get   'homes/mine', to: 'homes#mine'
    patch 'homes/mine', to: 'homes#update_mine'
    resources :homes

    get   'users/me', to: 'users#me'
    patch 'users/me', to: 'users#update_me'
    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
    resources :users

    get   'files/prepare-upload', to: 'files#prepare_upload'
    resources :files, only: [:show], param: :filename

    resources :followers, only: [:create, :show, :destroy]

    resources :feeds, only: [:index, :show, :destroy]
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
