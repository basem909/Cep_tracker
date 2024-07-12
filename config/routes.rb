Rails.application.routes.draw do
  root 'cep_search#index'
  post 'cep_search', to: 'cep_search#search'
  get 'statistics', to: 'statistics#index'
end
