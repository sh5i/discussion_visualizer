Rails.application.routes.draw do
  resources :issue_relations
  resources :projects
  devise_for :users
  resources :issues
  resources :comments do
    patch 'create_or_update', :on => :member
    post 'bookmark', :on => :member
    post 'association', :on => :member
    get 'tags', :on => :collection
  end
  resources :edges
  resources :tags
  resources :auto_tag_authors, :as => :settings, :path => 'settings'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resource :evaluations, only: [:index, :show] do
    get '', to: 'evaluations#index'
    get 'issues/:id', to: 'evaluations#user_select'
    get 'issues/:id/users/:uid', to: 'evaluations#show'
  end
  root to: "projects#index"
end
