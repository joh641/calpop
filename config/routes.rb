Calpop::Application.routes.draw do

  resource :populate
  root :to => redirect('/populate')

  get 'populate/apidoc' => 'populates#apidoc'
  
end
