Rails.application.routes.draw do

  devise_for :users
  root to: 'static_pages#index'
  resources :sources

  resources :public, only: [:show, :index, :update, :destroy]

  get '/.well-known/acme-challenge/:filename', to: 'certificates#show'

  get '/files/:id' => 'sources#show'

  scope :oauth do
    #resources :connections
    post '/connections/auth' => 'connections#authorize'
    get '/connections/callback' => 'connections#callback'
    get '/connections/errors' => 'connections#errors'
  end

  if Rails.env.deployment?
    mount LetterOpenerWeb::Engine, at: '/letter_opener'
  end
end
