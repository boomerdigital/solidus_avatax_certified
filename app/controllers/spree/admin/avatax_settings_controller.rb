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
        pingResult = mytax.ping
        if pingResult['ResultCode'] == 'Success'
          flash[:success] = 'Ping Successful'

        else
          flash[:error] = 'Ping Error'
        end

        respond_to do |format|
          format.js
        end
      end

      def validate_address
        mytax = TaxSvc.new
        address = permitted_address_validation_attrs

        address['Country'] = Spree::Country.find_by(id: address['Country']).try(:iso)
        address['Region'] = Spree::State.find_by(id: address['Region']).try(:abbr)

        response = mytax.validate_address(address)

        respond_to do |format|
          format.json { render json: response }
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
        if Spree::AvalaraPreference.origin_address.value.blank?
          @avatax_origin = {}
        else
          @avatax_origin = JSON.parse(Spree::AvalaraPreference.origin_address.value)
        end
      end

      def permitted_address_validation_attrs
        params['address'].permit(:Line1, :Line2, :City, :PostalCode, :Country, :Region).to_h
      end
    end
  end
end
