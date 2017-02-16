Rails.application.routes.draw do
  devise_for :users, controllers: {
        registrations: 'user/registrations', sessions: 'user/sessions'
  }

  put 'users/:id/save_avatar' => 'users#save_avatar', as: 'user_save_avatar'
  put 'groups/:id/save_cover_photo' => 'groups#save_cover_photo', as: 'groups_save_cover_photo'
  #put 'events/:id/save_cover_photo' => 'events#save_cover_photo', as: 'events_save_cover_photo'
  get "users/index"
  resources :groups

  resources :events do
    collection do
      get 'country_states_city' => 'events#country_states_city'
      get 'country_for_select' => 'events#country_for_select'
      get 'cities_for_select/:id' => 'events#cities_for_select'
      get 'states_for_select/:id' => 'events#states_for_select'
    end
  end

  resources :coments
  resources :posts

  root to: 'users#index'

end
