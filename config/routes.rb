Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  devise_scope :user do
    get 'addresses', to: 'users/registrations#new_address'
    post 'addresses', to: 'users/registrations#create_address'
    get '/users/sign_out', to: 'devise/sessions#destroy'
  end
  root to: "posts#index"
  resources :posts, only: [:index,:new, :show, :destroy]
  resources :users, only: [:show, :new]
  # 12行目にnewを加えていますが、これがログアウト画面を表示させるためのものです。
  # ※７つのアクションのうち、使わなそうなアクションを選んで、ビューまで作るように言われてたので、この実装をしています。
  # それ以外、newにしているこだわりはありません。
end
