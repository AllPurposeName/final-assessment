Rails.application.routes.draw do
  root "dashboard#index"

  get "/information", to: "information#show"
  post "/information", to: "information#create"
  get "/auth/:provider/callback", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
end
