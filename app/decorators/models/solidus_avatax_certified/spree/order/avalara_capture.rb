# frozen_string_literal: true

module SolidusAvataxCertified
  module Spree
    module Order
      module AvalaraCapture
        def self.prepended(base)
          base.has_one :avalara_transaction, dependent: :destroy

          base.state_machine.before_transition to: :canceled,
            do: :cancel_avalara,
            if: :avalara_tax_enabled?
          base.state_machine.before_transition to: :delivery,
            do: :validate_ship_address,
            if: :address_validation_enabled?
        end

        def avalara_tax_enabled?
          ::Spree::Avatax::Config.tax_calculation
        end

        def cancel_avalara
          return nil unless avalara_transaction.present?

          avalara_transaction.cancel_order
        end

        def avalara_capture
          logger.info "Start avalara_capture for order #{number}"

          create_avalara_transaction if avalara_transaction.nil?
          line_items.reload

          avalara_transaction.commit_avatax('SalesOrder')
        end

        def avalara_capture_finalize
          logger.info "Start avalara_capture_finalize for order #{number}"

          create_avalara_transaction if avalara_transaction.nil?
          line_items.reload

          avalara_transaction.commit_avatax_final('SalesInvoice')
        end

        def validate_ship_address
          avatax_address = SolidusAvataxCertified::Address.new(self)
          response = avatax_address.validate

          return response.result if response.success?
          return response if !::Spree::Avatax::Config.refuse_checkout_address_validation_error

          response.summary_messages.each do |msg|
            errors.add(:address_validation_failure, msg)
          end

          false
        end

        def avatax_cache_key
          key = ['Spree::Order']
          key << number
          key << promo_total
          key.join('-')
        end

        def customer_usage_type
          user ? user.avalara_entity_use_code.try(:use_code) : ''
        end

        def stock_locations
          stock_loc_ids = shipments.pluck(:stock_location_id).uniq
          ::Spree::StockLocation.where(id: stock_loc_ids)
        end

        def address_validation_enabled?
          return false if ship_address.nil?

          ship_address.validation_enabled?
        end

        def can_commit?
          completed? && payments.completed.any?
        end

        def logger
          @logger ||= SolidusAvataxCertified::AvataxLog.new('Spree::Order class', 'Start order processing')
        end
      end
    end
  end
end

Spree::Order.prepend SolidusAvataxCertified::Spree::Order::AvalaraCapture
