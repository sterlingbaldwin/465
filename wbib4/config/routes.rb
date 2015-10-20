Rails.application.routes.draw do
  resources :topics do
    resources :references, shallow: true
  end
  
  root 'topics#index'
end
