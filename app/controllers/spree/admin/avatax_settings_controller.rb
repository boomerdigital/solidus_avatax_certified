module Spree
  module Admin
    class AvataxSettingsController < Spree::Admin::BaseController

      before_filter :load_avatax_origin, only: [:show, :edit]

      def show
      end

      def get_file_txt_tax_svc
        send_file "#{Rails.root}/log/tax_svc.log"
      end

      def get_file_post_order_to_avalara
        send_file "#{Rails.root}/log/post_order_to_avalara.log"
      end

      def get_file_avalara_order
        send_file "#{Rails.root}/log/avalara_order.log"
      end

      def erase_data
        File.open("log/#{params['log_name']}.log", 'w') {}

        render nothing: true
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
        address = params['address']

        if address['Country'].to_i != 0
          address['Country'] = Spree::Country.find(address['Country']).try(:iso)
        end

        if address['Region'].to_i != 0
          address['Region'] = Spree::State.find(address['Region']).try(:abbr)
        end

        response = mytax.validate_address(address)

        if response['ResultCode'] == 'Success'
          flash[:success] = 'Address Validation Successful'
        else
          flash[:error] = 'Address Validation Error'
        end

        respond_to do |format|
          format.js
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
    end
  end
end
