Apod2::Application.routes.draw do
  root controller: 'pictures', action: 'index'

  resources :pictures, only: [:index, :show]
end
