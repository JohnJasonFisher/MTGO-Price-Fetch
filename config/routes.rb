Rails.application.routes.draw do

  get '' => 'sessions#new'
  get '/usercards' => 'usercards#index'
  get '/usercards/add' => 'usercards#new'
  get '/usercards/stats' => 'usercards#stats'
  post '/usercards/add' => 'usercards#create'
  get '/usercards/:card_id/edit' => 'usercards#edit'
  patch '/usercards/:id' => 'usercards#update'
  delete '/usercards/:id' => 'usercards#destroy'


  get '/cards/:id' => 'cards#show'
  delete '/cards/:id' => 'card_user#destroy'

  get '/signup' => 'users#new'
  post '/signup' => 'users#create'

  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'

  get '/alert' => 'alert#alert_seller'

  namespace :api do
    namespace :v1 do
      get '/usercards' => 'usercards#index'
    end
  end
end
