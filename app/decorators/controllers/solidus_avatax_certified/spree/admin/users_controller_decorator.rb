module SolidusAvataxCertified
  module Spree
    module Admin
      module UsersControllerDecorator
        def avalara_information
          if request.put?
            if @user.update(user_params)
              flash.now[:success] = I18n.t(:account_updated)
            end
          end

          render :avalara_information
        end

        ::Spree::Admin::UsersController.prepend self
      end
    end
  end
end
