# frozen_string_literal: true

require 'spec_helper'

# Failing spec for DOC-24 (discount handling) — the TARGET behavior.
#
# Per Jason's guidance and Avalara's certification discount scenario
# ("you can send us post-discounted amounts"), discounts must be NETTED into
# each line's extended amount so AvaTax computes tax on the discounted price,
# rather than being sent as separate negative `-ADJ` line items.
#
# This is expected to FAIL on today's code and PASS once line.rb nets discounts
# into item (and shipment) lines. It is promotion-system-agnostic: discounts are
# created as plain Spree::Adjustment records, so it holds for both legacy and new
# (solidus_promotions) stores, which both persist Spree::Adjustment rows.
#
# Case matrix covered here:
#   - line-level discount   -> netted via line_item.total_before_tax
#   - order-level discount  -> distributed proportionally across item lines
#                              (Spree::DistributedAmountsHandler), never onto freight
describe SolidusAvataxCertified::Line, :vcr do
  let!(:order) { create(:avalara_order, line_items_count: 2, line_items_price: BigDecimal(10)) }
  let(:sales_lines) { described_class.new(order, 'SalesOrder') }

  def lines_of_type(lines, suffix)
    lines.select { |l| l[:number].to_s.end_with?(suffix) }
  end

  it 'never emits a separate -ADJ discount line' do
    Spree::Adjustment.create!(
      order: order, adjustable: order.line_items.first, source: nil,
      amount: -2.0, label: 'Line Discount', eligible: true
    )
    order.reload
    expect(lines_of_type(sales_lines.lines, '-ADJ')).to be_empty
  end

  context 'with a line-level discount' do
    let(:line_item) { order.line_items.first }

    before do
      Spree::Adjustment.create!(
        order: order, adjustable: line_item, source: nil,
        amount: -2.0, label: 'Line Discount', eligible: true
      )
      order.reload
    end

    it 'nets the discount into the item line amount (post-discount price)' do
      li = order.line_items.first
      expect(sales_lines.item_line(li)[:amount]).to eq(li.total_before_tax.to_f)
      expect(sales_lines.item_line(li)[:amount]).to eq(8.0)
    end

    it 'leaves undiscounted lines at full price' do
      other = order.line_items.last
      expect(sales_lines.item_line(other)[:amount]).to eq(10.0)
    end

    it 'no longer carries the vestigial discounted flag' do
      expect(sales_lines.item_line(order.line_items.first)).not_to have_key(:discounted)
    end
  end

  context 'with an order-level discount' do
    before do
      Spree::Adjustment.create!(
        order: order, adjustable: order, source: nil,
        amount: -5.0, label: 'Order Discount', eligible: true
      )
      order.reload
    end

    it 'distributes the order discount proportionally across item lines' do
      item_lines = lines_of_type(sales_lines.lines, '-LI')
      # $5 spread over two equal $10 lines => $2.50 each => $7.50 net per line
      expect(item_lines.map { |l| l[:amount] }).to all(eq(7.5))
      expect(item_lines.sum { |l| l[:amount] }).to eq(15.0)
    end

    it 'does not apply the order discount to the shipment/freight line' do
      freight = lines_of_type(sales_lines.lines, '-FR') + sales_lines.lines.select { |l| l[:description] == 'Shipping Charge' }
      shipment_line = sales_lines.shipment_line(order.shipments.first)
      # freight stays at full shipment cost; the discount never touches it
      expect(shipment_line[:amount]).to eq(order.shipments.first.total_before_tax.to_f)
    end
  end
end
