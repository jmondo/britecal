BriteCal::Application.routes.draw do
  root :to => "pages#index"
  match 'auth/eventbrite/callback' => 'sessions#create'
  resource :session, only: [:destroy]
  resources :calendars, only: [:show]

  match 'cal/:cal_token' => 'calendars#show', as: :ical
end
