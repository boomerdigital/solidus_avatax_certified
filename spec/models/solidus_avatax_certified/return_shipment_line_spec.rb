# frozen_string_literal: true

require 'spec_helper'

# Covers the "shipping line on returns" behavior required by the Avalara
# Refunds advanced-feature test transaction: a ReturnInvoice must be able to
# include a negative freight line (e.g. taxCode FR020100) alongside the
# negative product lines.
describe SolidusAvataxCertified::Line, :vcr do
  let(:reimbursement) { create(:reimbursement, return_items_count: 2) }
  let(:order) { reimbursement.order }
  let(:refund) { create(:refund, payment: order.payments.first, reimbursement: reimbursement) }
  let(:return_lines) { described_class.new(order, 'ReturnInvoice', refund) }

  def freight_lines(lines)
    lines.select { |l| l[:number].to_s.end_with?('-FR') }
  end

  def product_lines(lines)
    lines.select { |l| l[:number].to_s.end_with?('-LI') }
  end

  # --- Characterization: pin the existing product-line behavior so the fix
  #     does not regress it. ---
  describe 'existing return product lines (characterization)' do
    it 'emits one negative product line per returned line item' do
      lines = product_lines(return_lines.lines)

      expect(lines.length).to eq(2)
      expect(lines.map { |l| l[:amount] }).to all(be < 0)
      expect(lines.map { |l| l[:taxCode] }).to all(be_present)
    end
  end

  # --- New behavior: freight line on returns. ---
  describe 'freight line on returns' do
    context 'when the returned shipment has a tax category' do
      let(:freight_tax_code) { 'FR020100' }
      let(:freight_tax_category) { create(:tax_category, tax_code: freight_tax_code) }

      before do
        order.shipments.each { |s| s.shipping_method.update!(tax_category: freight_tax_category) }
      end

      it 'includes a negative freight line carrying the shipping tax code' do
        freight = freight_lines(return_lines.lines)

        expect(freight.length).to eq(1)
        expect(freight.first[:amount]).to be < 0
        expect(freight.first[:taxCode]).to eq(freight_tax_code)
        expect(freight.first[:description]).to eq('Shipping Charge')
      end

      it 'still emits the product lines alongside the freight line' do
        expect(product_lines(return_lines.lines).length).to eq(2)
      end
    end

    context 'when the returned shipment has no tax category' do
      it 'does not add a freight line (mirrors the sales-side guard)' do
        expect(freight_lines(return_lines.lines)).to be_empty
      end
    end
  end
end
