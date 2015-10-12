Rails.application.routes.draw do
  resources :references
  resources :topics

  root 'topics#index'
end
