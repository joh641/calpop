Calpop::Application.routes.draw do

  resource :populate
  resources :departments
  resources :classinstances
  resources :sections
  resources :timeslots
  root :to => redirect('/populate')
end
