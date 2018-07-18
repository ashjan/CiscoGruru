Rails.application.routes.draw do
  # site {{{1
  root 'site#index'

  get '/terms-of-service' => 'site#terms_of_service'
  get '/privacy' => 'site#privacy'
  get '/pricing' => 'site#pricing'
  get '/changelog' => 'site#changelog'
  get '/translations' => 'site#translations'
  # }}}
  # designer {{{1
  get '/designer' => 'designer#index'
  get '/designer/schema/:schema_no' => 'designer#index'
  get '/designer/schema/:schema_no/versions' => 'designer#versions'
  get '/designer/schema/:schema_no/version/:version_id' => 'designer#show_version'
  # }}}
  # sessions {{{1
  get '/login', to: 'sessions#new', as: 'login'
  get '/logout', to: 'sessions#destroy', as: 'logout'
  post '/logout', to: 'sessions#destroy'
  get '/auth/:provider/callback', to: 'sessions#oauth'
  get '/auth/failure', to: 'sessions#auth_failure'
  ## password recovery {{{2
  get '/password-recovery/remind-password', to: 'sessions#remind_password'
  post '/password-recovery/send-reminder', to: 'sessions#send_reminder'
  get '/password-recovery/reminder-sent', to: 'sessions#reminder_sent'
  get '/recover/:token', to: 'sessions#recover'
  post '/password-recovery/change-password', to: 'sessions#change_password'
  ## }}}
  resources :sessions, only: [:index, :new, :create, :destroy]
  # }}}
  # registration {{{1
  get '/signup', to: 'registrations#new', as: 'signup'
  resources :registrations, only: [:new, :create, :index] do
    get 'invite/:token', to: 'registrations#invite', on: :collection
    get 'thankyou', to: 'registrations#thankyou', on: :collection
  end
  # }}}
  # users {{{1
  # resources :users
  post '/users/update_profile' => 'users#update_profile'
  post '/users/save_settings' => 'users#save_settings'
  post '/users/notify' => 'users#notify'
  get '/account' => 'users#account', as: 'user_account'
  patch '/update-account' => 'users#update_account', as: 'update_account'
  resources :feedbacks, only: [:index, :create, :destroy] do
    get 'toggle_answered', on: :member
  end
  # }}}
  # administration {{{1
  get '/yonetim' => 'admin#index'
  get '/yonetim/users' => 'admin#users'
  get '/yonetim/user/:id' => 'admin#show_user'
  get '/yonetim/user/:id/set_translator' => 'admin#set_translator', as: :admin_set_translator
  get '/yonetim/schemata' => 'admin#schemata'
  get '/yonetim/schema/:id' => 'admin#schema'
  get '/yonetim/feedbacks' => 'admin#feedbacks'
  get '/yonetim/feedback/:id' => 'admin#feedback'
  get '/yonetim/comments' => 'admin#comments'
  get '/yonetim/blog/new' => 'admin#new_article'
  get '/yonetim/blog' => 'admin#blog'
  post '/yonetim/blog/create' => 'admin#create_article'
  get '/yonetim/blog/edit/:id' => 'admin#edit_article'
  post '/yonetim/blog/update/:id' => 'admin#update_article'
  get '/yonetim/search' => 'admin#search'
  post '/yonetim/search' => 'admin#search'
  get '/yonetim/adv_search' => 'admin#adv_search'
  post '/yonetim/adv_search' => 'admin#adv_search'
  get '/yonetim/logins' => 'admin#logins'
  get '/yonetim/payments' => 'admin#payments'
  get '/ghost/:id' => 'admin#ghost', as: :admin_ghost
  # }}}
  # blog {{{1
  get '/blog/:slug---:id' => 'blog#show'
  get '/blog' => 'blog#index'
  # }}}
  # help {{{1
  get '/help/' => 'help#index'
  get '/help/exporting' => 'help#exporting'
  get '/help/sharing' => 'help#sharing'
  get '/help/realtime' => 'help#realtime'
  # }}}
  # api {{{1
  namespace :api, :defaults => {:format => :json} do
    namespace :v1 do
      resources :schemas do
        post 'generate_sql', on: :member
        collection do
          get 'templates'
          get 'wait'
          post 'import_sql'
        end
        resources :schema_comments, only: [:index, :create, :destroy]
        resources :collaborators, only: [:index, :create, :destroy]
      end
      post 'paddle_alert' => 'paddle#hook_callback'
    end
  end
  # }}}
  # misc {{{1
  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  # }}}
end
