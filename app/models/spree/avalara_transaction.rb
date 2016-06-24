require_dependency 'spree/order'

module Spree
  class AvalaraTransaction < Spree::Base
    belongs_to :order
    validates :order, presence: true
    validates :order_id, uniqueness: true
  end
end
