Rails.application.routes.draw do
  devise_for :users

  root "home#welcome"
  resources :genres, only: :index do
    member do
      get "movies"
    end
  end
  resources :movies, only: [:index, :show] do
    member do
      get :send_info
    end
    collection do
      get :export
    end
    resources :comments, module: :movies, only: [:create, :destroy]
  end

  get "comments/top_commenters" => "comments#top_commenters", as: :top_commenters
end
