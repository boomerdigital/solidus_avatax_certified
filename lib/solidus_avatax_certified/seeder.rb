module SolidusAvataxCertified
  class Seeder
    class << self

      def seed!
        create_use_codes
        create_tax
        add_tax_category_to_shipping_methods
        populate_default_stock_location

        puts "***** SOLIDUS AVATAX CERTIFIED *****"
        puts ""
        puts "Please remember to:"
        puts "- Add tax category to all shipping methods that need to be taxed."
        puts "- Don't assign anything default tax."
        puts "- Fill in Stock Location Address."
        puts "- Fill Origin Address in Avatax Settings."
        puts ""
        puts "***** SOLIDUS AVATAX CERTIFIED *****"
      end

      def seed_use_codes!
        create_use_codes
        puts "***** SOLIDUS AVATAX CERTIFIED: Use Codes Seeded"
      end

      def create_tax
        default_tax_category = Spree::TaxCategory.find_by(name: 'Default')
        default_tax_rate = Spree::TaxRate.find_by(name: 'North America')

        default_tax_category.destroy if default_tax_category
        default_tax_rate.destroy if default_tax_rate

        clothing = Spree::TaxCategory.find_or_create_by(name: 'Clothing')
        clothing.update_attributes(tax_code: 'P0000000')

        shipping = Spree::TaxCategory.find_or_create_by(name: 'Shipping', tax_code: 'FR000000')

        sales_tax = Spree::TaxRate.create(tax_category: clothing, name: 'Tax', amount: BigDecimal.new('0'), zone: Spree::Zone.find_by_name('North America'), show_rate_in_label: false)
        sales_tax.calculator = Spree::Calculator::AvalaraTransaction.create!
        sales_tax.save!

        shipping_tax = Spree::TaxRate.create(name: 'Shipping Tax', tax_category: shipping, amount: BigDecimal.new('0'), zone: Spree::Zone.find_by_name('North America'), show_rate_in_label: false)
        shipping_tax.calculator = Spree::Calculator::AvalaraTransaction.create!
        shipping_tax.save!
      end

      def add_tax_category_to_shipping_methods
        Spree::ShippingMethod.all.each do |shipping_method|
          shipping_method.update_attributes(tax_category: Spree::TaxCategory.find_by(name: 'Shipping'))
        end
      end

      def populate_default_stock_location
        default = Spree::StockLocation.find_by(name: 'default')
        default.destroy if default

        state = Spree::State.find_by(name: 'Alabama')

        address = {
          address1: '915 S Jackson St',
          city: 'Montgomery',
          state: state,
          country: state.country,
          zipcode: '36104',
          default: true,
          name: 'default',
          backorderable_default: true
        }

        Spree::StockLocation.create(address)
      end

      def create_use_codes
        unless Spree::AvalaraEntityUseCode.count >= 16
          use_codes.each do |key, value|
            Spree::AvalaraEntityUseCode.find_or_create_by(use_code: key, use_code_description: value)
          end
        end
      end

      def use_codes
        {
          "A" => "Federal government",
          "B" => "State government",
          "C" => "Tribe/Status Indian/Indian Band",
          "D" => "Foreign diplomat",
          "E" => "Charitable or benevolent organization",
          "F" => "Religious or educational organization",
          "G" => "Resale",
          "H" => "Commercial agricultural production",
          "I" => "Industrial production/manufacturer",
          "J" => "Direct pay permit",
          "K" => "Direct mail",
          "L" => "Other",
          "N" => "Local government",
          "P" => "Commercial aquaculture (Canada only)",
          "Q" => "Commercial fishery (Canada only)",
          "R" => "Non-resident (Canada only)"
        }
      end
    end
  end
end
