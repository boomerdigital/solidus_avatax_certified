# frozen_string_literal: true

module Spree
  module Admin
    class AvalaraEntityUseCodesController < Spree::Admin::ResourceController
      def index
        @avalara_entity_use_codes = Spree::AvalaraEntityUseCode.all

        respond_to do |format|
          format.html
          format.json { render json: @avalara_entity_use_codes }
        end
      end
    end
  end
end
