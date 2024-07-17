Rails.application.routes.draw do

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  get "hello" => "hello#hello"

  post "/api/v1/auth/sign_up" => "auth#sign_up"
  post "/api/v1/auth/login" => "auth#login"

  get "/api/v1/exams" => "exam#get_exams"
  get "/api/v1/exams/available_times" => "exam#get_available_time"
  post "/api/v1/exams/request" => "exam#reserve_request"
  patch "/api/v1/exams/:exam_id/confirm" => "exam#confirm"
  patch "/api/v1/exams/:exam_id" => "exam#update_exam"
  delete "/api/v1/exams/:exam_id" => "exam#delete_exam"

  get 'swagger/index' => 'swagger#index'
  mount Rswag::Api::Engine => '/api-docs'
  mount Rswag::Ui::Engine => '/api-docs'

  # get '/api-docs' => 'swagger#index'
  # mount Rswag::Ui::Engine => '/api-docs'
  # mount Rswag::Api::Engine => '/api-docs'

  # Defines the root path route ("/")
  # root "posts#index"
end
