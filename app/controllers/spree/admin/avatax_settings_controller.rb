module Spree
  module Admin
    class AvataxSettingsController < Spree::Admin::BaseController

      before_action :load_avatax_origin, only: [:show, :edit]

      def show
      end

      def download_avatax_log
        send_file "#{Rails.root}/log/avatax.log"
      end

      def erase_data
        File.open("log/avatax.log", 'w') {}

        head :ok
      end

      def ping_my_service
        mytax = TaxSvc.new
        response = mytax.ping

        if response.success?
          flash[:success] = 'Ping Successful'

        else
          flash[:error] = 'Ping Error'
        end

        respond_to do |format|
          format.html { render :layout => !request.xhr? }
          format.js { render :layout => false }
        end
      end

      def validate_address
        mytax = TaxSvc.new
        address = permitted_address_validation_attrs

        address['country'] = Spree::Country.find_by(id: address['country']).try(:iso)
        address['region'] = Spree::State.find_by(id: address['region']).try(:abbr)

        response = mytax.validate_address(address)
        result = response.result

        if response.failed?
          result.merge!({ 'responseCode': 'error', 'errorMessages': response.summary_messages })
        end

        respond_to do |format|
          format.json { render json: result }
        end
      end

      def update
        updater = SolidusAvataxCertified::PreferenceUpdater.new(params)
        if updater.update
          redirect_to admin_avatax_settings_path
        else
          flash[:error] = 'There was an error updating your Avalara Preferences'
          redirect_to :back
        end
      end

      private

      def load_avatax_origin
        if Spree::Avatax::Config.origin.blank?
          @avatax_origin = {}
        else
          @avatax_origin = JSON.parse(Spree::Avatax::Config.origin)
        end
      end

      def permitted_address_validation_attrs
        params['address'].permit(:line1, :line2, :city, :postalCode, :country, :region).to_h
      end
    end
  end
end
