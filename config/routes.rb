Rails.application.routes.draw do
  root "dashboard#home"
  post "/", to: "dashboard#upload_file"
  resources :import_rows
  resources :imports
  resources :units
  resources :properties
end
