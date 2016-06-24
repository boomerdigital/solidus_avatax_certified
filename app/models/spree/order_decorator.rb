Spree::Order.class_eval do
  has_one :avalara_transaction, dependent: :destroy
end
