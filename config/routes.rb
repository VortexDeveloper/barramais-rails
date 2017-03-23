Rails.application.routes.draw do
  get 'barrachat/index'

  devise_for :users, controllers: {
        registrations: 'user/registrations', sessions: 'user/sessions'
  }

  root to: 'users#index'

  resources :users do
    collection do
      put ':id/save_avatar' => 'users#save_avatar', as: 'user_save_avatar'
      get "index"
      get 'event_friends/:event' => 'users#event_friends'
      get 'my_events/:id' => 'users#my_events'
      get 'my_pending_invitations/:id' => 'users#my_pending_invitations'
      get 'my_refused_invitations/:id' => 'users#my_refused_invitations'
      get 'my_confirmed_invitations/:id' => 'users#my_confirmed_invitations'
      get 'confirmed_events/:id' => 'users#confirmed_events'
      get 'refused_events/:id' => 'users#refused_events'
      get 'pending_events/:id' => 'users#pending_events'
      put 'accept_event/:id' => 'users#accept_event'
      put 'refuse_event/:id' => 'users#refuse_event'
      get 'user_advertiser/:id' => 'users#user_advertiser'
      get 'user_friends/:id' => 'users#user_friends'
      get 'pending_friends' => 'users#pending_friends'
      get 'accept_friendship/:id' => 'users#accept_friendship'
      get 'refuse_friendship/:id' => 'users#refuse_friendship'
      get 'request_friendship/:id' => 'users#request_friendship'
      get 'is_friend_of/:id' => 'users#is_friend_of'
      get 'event_friends/:event' => 'users#event_friends'
      get 'pending_friendships' => 'users#pending_friendships'
      get 'unfriend/:id' => 'users#unfriend'
    end
  end



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
  resources :barrachat, only: [:index]
  resources :conversations, only: [:index, :create] do
    member do
      post :close
    end
    collection do
      get :conversations
    end
    resources :messages, only: [:create, :index]
  end

  resources :advertisers do
    collection do
      get 'country_for_select' => 'advertisers#country_for_select'
      get 'cities_for_select/:id' => 'advertisers#cities_for_select'
      get 'states_for_select/:id' => 'advertisers#states_for_select'
      get 'all_ads/:id' => 'advertisers#all_ads'
      post 'create_ad/:id' => 'advertisers#create_ad'
      post 'update_ad/:id' => 'advertisers#update_ad'
    end
  end

  resources :ads do
    collection do
      get 'interest_list' => 'ads#interest_list'
      get 'ad_area/:id' => 'ads#ad_area'
    end
  end

  resources :interest_areas
end
