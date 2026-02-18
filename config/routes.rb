Rails.application.routes.draw do
  root "dashboard#home"
  post "/", to: "dashboard#upload_file"
  resources :import_rows
  resources :imports do
    resources :import_rows
  end
  resources :units
  resources :properties
end
