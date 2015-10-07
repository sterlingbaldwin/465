Rails.application.routes.draw do
	root 'home#index'
	get '/words', to:'home#words'
end
