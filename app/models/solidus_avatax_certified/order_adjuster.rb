module SolidusAvataxCertified
  class OrderAdjuster < Spree::Tax::OrderAdjuster

    def adjust!
      if %w(cart address delivery).include?(order.state)
        return (order.line_items + order.shipments)
      end

      super
    end
  end
end
