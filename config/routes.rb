Rails.application.routes.draw do
  get 'barrachat/index'

  devise_for :users, controllers: {
        registrations: 'user/registrations', sessions: 'user/sessions'
  }

  root to: 'users#index'

  resources :users do
    collection do
      put ':id/save_avatar' => 'users#save_avatar', as: 'user_save_avatar'
      put ':id/save_cover_photo' => 'users#save_cover_photo', as: 'user_save_cover_photo'
      get "index"
      get 'event_friends/:event' => 'users#event_friends'
      get 'group_friends/:group' => 'users#group_friends'
      get 'my_events/:id' => 'users#my_events'
      get 'my_pending_invitations/:id' => 'users#my_pending_invitations'
      get 'my_refused_invitations/:id' => 'users#my_refused_invitations'
      get 'my_confirmed_invitations/:id' => 'users#my_confirmed_invitations'
      get 'confirmed_events/:id' => 'users#confirmed_events'
      get 'refused_events/:id' => 'users#refused_events'
      get 'pending_events/:id' => 'users#pending_events'
      put 'accept_event/:event' => 'users#accept_event'
      put 'refuse_event/:event' => 'users#refuse_event'
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
      put 'accept_group' => 'users#accept_group'
      put 'refuse_group' => 'users#refuse_group'
      get 'confirmed_groups' => 'users#confirmed_groups'
      get 'refused_groups' => 'users#refused_groups'
      get 'pending_groups' => 'users#pending_groups'
      get 'my_groups' => 'users#my_groups'
      get 'load_nautical_sports' => 'users#load_nautical_sports'
      get 'load_state_for_travels' => 'users#load_state_for_travels'
      get 'load_country_for_travels' => 'users#load_country_for_travels'
      put 'update_user_interests/:id' => 'users#update_user_interests'
      put 'update_user_nautical_sports/:id' => 'users#update_user_nautical_sports'
      get 'open_all_user_notifications/:id' => 'users#open_all_user_notifications'
    end
    resources :own_vessels
  end



  resources :groups do
    collection do
      get 'all_members/:id' => 'groups#all_members'
      get 'confirmed_members/:id' => 'groups#confirmed_members'
      get 'pending_by_admin/:id' => 'groups#pending_by_admin'
      get 'pending_by_user/:id' => 'groups#pending_by_user'
      get 'refused_members/:id' => 'groups#refused_members'
      put 'invitation/:id' => 'groups#invitation'
      put 'save_cover_photo/:id' => 'groups#save_cover_photo'
    end
  end

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

  resources :comments

  resources :posts do
    member do
      get :like
      post :comment
      get :comments
    end
    collection do
      get :enrich_link
    end
  end
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

  resources :classifieds do
    collection do
      post 'create_vessel' => 'classifieds#create_vessel'
      post 'create_fishing' => 'classifieds#create_fishing'
      get 'get_classifieds_by_user/:id' => 'classifieds#get_classifieds_by_user'
      get 'get_brand_by_id/:id' => 'classifieds#get_brand_by_id'
      get 'get_mold_by_id/:id' => 'classifieds#get_mold_by_id'
      get 'brands_for_select' => 'classifieds#brands_for_select'
      get 'molds_for_select/:id' => 'classifieds#molds_for_select'
      get 'accessories_for_select' => 'classifieds#accessories_for_select'
      get 'communications_for_select' => 'classifieds#communications_for_select'
      get 'eletronics_for_select' => 'classifieds#eletronics_for_select'
      get 'get_fishing_category_by_id/:id' => 'classifieds#get_fishing_category_by_id'
      get 'get_fishing_sub_category_by_id/:id' => 'classifieds#get_fishing_sub_category_by_id'
      get 'fishing_categories_for_select' => 'classifieds#fishing_categories_for_select'
      get 'fishing_sub_categories_for_select/:id' => 'classifieds#fishing_sub_categories_for_select'
    end
  end

  resources :album_photos do
    collection do
      get 'get_user_album/:id' => 'album_photos#get_user_album'
    end
  end

  resources :interests do
    collection do
      get 'get_interests_by_user/:id' => 'interests#get_interests_by_user'
    end
  end

  resources :nautical_sports do
    collection do
      get 'get_nautical_sports_by_user/:id' => 'nautical_sports#get_nautical_sports_by_user'
    end
  end

  notify_to :users,                       controllers: 'users/notifications'
  notify_to :admins, with_devise: :users, controllers: 'admins/notifications_with_devise'

  # get '/users/:id/notifications/check_notifications' => 'users/notifications#check_notifications'
end
