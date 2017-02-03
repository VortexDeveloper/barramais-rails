Rails.application.routes.draw do
  devise_for :users, controllers: {
        registrations: 'user/registrations', sessions: 'user/sessions'
  }

  put 'users/:id/save_avatar' => 'users#save_avatar', as: 'user_save_avatar'
  put 'groups/:id/save_cover_photo' => 'groups#save_cover_photo', as: 'groups_save_cover_photo'
  put 'events/:id/save_cover_photo' => 'events#save_cover_photo', as: 'events_save_cover_photo'
  get "users/index"
  resources :groups
  resources :events



  root to: 'users#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
