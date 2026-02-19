Rails.application.routes.draw do
  root "dashboard#home"
  post "/", to: "dashboard#upload_file"

  resources :import_rows
  resources :imports do

    resources :import_rows
    post "/commit", to: "imports#commit_import", as: "commit"
    post "/validate", to: "imports#validate_import", as: "validate"
  end

  resources :units
  resources :properties do
    resources :units
  end
end
