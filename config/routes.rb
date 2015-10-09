Rails.application.routes.draw do
  root "dashboard#index"
  get "/dashboard", to: "dashboard#show"
  put "/dashboard", to: "dashboard#update"
  patch "/dashboard", to: "dashboard#update"

  get "/information", to: "information#show"
  post "/information", to: "information#create"
  get "/auth/:provider/callback", to: "sessions#create"

  delete "/logout", to: "sessions#destroy", as: "logout_path"
end
