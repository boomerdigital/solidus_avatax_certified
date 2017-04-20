Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :avalara_entity_use_codes

    resource :avatax_settings do
      get :ping_my_service, :download_avatax_log, :erase_data, :validate_address
    end

    resources :users do
      member do
        get :avalara_information
        put :avalara_information
      end
    end
  end

  get '/checkout/validate_address', to: 'checkout#validate_address', as: :validate_address
end
