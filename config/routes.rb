Rails.application.routes.draw do
  root "dashboard#home"
  resources :import_rows
  resources :imports
  resources :units
  resources :properties
end
