# frozen_string_literal: true

module Spree
  module Admin
    class AvataxSettingsController < Spree::Admin::BaseController
      before_action :load_avatax_origin, only: %i[show]

      def show; end

      def download_avatax_log
        send_file "#{Rails.root}/log/avatax.log"
      end

      def erase_data
        File.open("log/avatax.log", 'w') {}

        head :ok
      end

      def validate_ship_address
        mytax = TaxSvc.new
        address = params[:address].permit(:line1, :line2, :city, :postalCode, :country, :region).to_h

        address['country'] = Spree::Country.find_by(id: address['country']).try(:iso)
        address['region'] = Spree::State.find_by(id: address['region']).try(:abbr)

        response = mytax.validate_address(address)
        result = response.result

        if response.failed?
          result['responseCode'] = 'error'
          result['errorMessages'] = response.summary_messages
        end

        respond_to do |format|
          format.json { render json: result }
        end
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
          format.html { render layout: !request.xhr? }
          format.js { render layout: false }
        end
      end

      private

      def load_avatax_origin
        @avatax_origin = if Spree::Avatax::Config.origin.blank?
                           {}
                         else
                           JSON.parse(Spree::Avatax::Config.origin)
                         end
      end
    end
  end
end
