Rails.application.routes.draw do
  devise_for :users, controllers: {
        registrations: 'user/registrations', sessions: 'user/sessions'
  }
  put 'users/:id/save_avatar' => 'users#save_avatar', as: 'user_save_avatar'

  root to: 'users#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
