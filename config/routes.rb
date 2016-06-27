Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :avalara_entity_use_codes
  end
end
