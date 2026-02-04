Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  post "/auth/google", to: "auth#google"

  post "/videos/presign", to: "videos#presign"
  post "/videos", to: "videos#create"
  get  "/videos", to: "videos#index"
  post "videos/complete", to: "videos#complete"
  get "/videos/:id/stream", to: "videos#stream"

end
