Rails.application.routes.draw do
	namespace :admin do
		namespace :simple_list do
			get ':model_class', to: 'lists#index'
			post ':model_class', to: 'lists#create'
			get ':model_class/list', to: 'lists#list'
			get ':model_class/new', to: 'lists#new'
			get ':model_class/:id', to: 'lists#show'
			get ':model_class/:id/edit', to: 'lists#edit'
			put ':model_class/:id', to: 'lists#update'
			delete ':model_class/:id', to: 'lists#destroy'
		end
	end
end
