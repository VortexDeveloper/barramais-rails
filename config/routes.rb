Rails.application.routes.draw do
  devise_for :users, controllers: {
        registrations: 'user/registrations', sessions: 'user/sessions'
  }

  root to: 'users#index'

  put 'users/:id/save_avatar' => 'users#save_avatar', as: 'user_save_avatar'
  get "users/index"
  get 'users/friends'
  get 'users/my_events/:id' => 'users#my_events'
  get 'users/confirmed_events/:id' => 'users#confirmed_events'
  get 'users/refused_events/:id' => 'users#refused_events'
  get 'users/pending_events/:id' => 'users#pending_events'
  put 'users/accept_event/:id' => 'users#accept_event'
  put 'users/refuse_event/:id' => 'users#refuse_event'

  resources :groups

  resources :events do
    collection do
      get 'country_states_city' => 'events#country_states_city'
      get 'country_for_select' => 'events#country_for_select'
      get 'cities_for_select/:id' => 'events#cities_for_select'
      get 'states_for_select/:id' => 'events#states_for_select'
      get 'all_guests/:id' => 'events#all_guests'
      get 'confirmed_guests/:id' => 'events#confirmed_guests'
      get 'pending_guests/:id' => 'events#pending_guests'
      get 'refused_guests/:id' => 'events#refused_guests'
      put 'invitation/:id' => 'events#invitation'
    end
  end

  resources :coments
  resources :posts

  resources :advertisers do
    collection do
      get 'country_for_select' => 'advertisers#country_for_select'
      get 'cities_for_select/:id' => 'advertisers#cities_for_select'
      get 'states_for_select/:id' => 'advertisers#states_for_select'

    end
  end


end
