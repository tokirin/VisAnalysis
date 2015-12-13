Rails.application.routes.draw do
  root 'application#index'

  # routing table
  get '/:id' => 'analytics#show'
  #ajax api
  mount API::Ajax =>'/ajax'
end
