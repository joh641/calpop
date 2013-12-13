Calpop::Application.routes.draw do

  resource :populate
  root :to => redirect('/populate')
end
