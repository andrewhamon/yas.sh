Rails.application.routes.draw do
  get 'me', to: 'accounts#me'
  resources :accounts

  resource :authorizations, path: :auth

  resources :sites, id: /([^\/])+?/ do
    resources :revisions do
      member do
        post 'commit'
      end
      resources :files
    end
  end

  get "/.well-known/yassh-challenge/:domain_prevalidation_token", to: "sites#prevalidate"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
