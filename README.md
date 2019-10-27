# solidus_avatax_certified

[![CircleCI](https://circleci.com/gh/boomerdigital/solidus_avatax_certified.svg?style=svg)](https://circleci.com/gh/boomerdigital/solidus_avatax_certified)

solidus_avatax_certified is the *only* [officially certified AvaTax solution](https://www.avalara.com/legal/avalara-certified.html)
that integrates with Solidus. With this extension, you can add instantaneous sales tax decisions to
your store.

From Avalara's own explanation of the certification program:

> Relax. It’s certified.
>
> Our “Certified for AvaTax” Program features integrations that perform at the highest level,
> providing the best possible customer experience.
>
> Avalara’s partners who have created certified integrations for AvaTax have demonstrated that those
> integrations contain elements which are essential to providing customers with easy-to-use software
> that gives accurate sales tax calculations. The certification criteria used to demonstrate these
> elements are based on Avalara’s years of experience integrating into ERP, ecommerce and
> point-of-sale applications.

**[For Installation and Setup instructions, please visit our wiki.](https://github.com/boomerdigital/solidus_avatax_certified/wiki)**

## Version compatibility

| Solidus version | Branch    | Latest AvaTax version |
|:---------------:|:---------:|:---------------------:|
| v1.0 - v2.0     | v1.0-v2.0 | 1.1.0                 |
| v2.1 - v2.2     | v2.1-2.2  | 2.0.0                 |
| v2.3 - master   | master    | 3.0.0                 |

## Installation

### 1. Install the gem

First of all, install the gem:

```console
$ gem 'solidus_avatax_certified', github: 'boomerdigital/solidus_avatax_certified'
$ bundle install
$ bundle exec rails g solidus_avatax_certified:install
```

### 2. Configure the gem

Once you're done with the setup, you have to configure the gem. You can do this via an initializer
or, for some option, via environment variables. The defaults are shown below:

```ruby
# config/initializers/avatax.rb
Spree::Avatax::Config.configure do |config|
  config.company_code = ENV['AVATAX_COMPANY_CODE']
  config.license_key = ENV['AVATAX_LICENSE_KEY']
  config.account = ENV['AVATAX_ACCOUNT']
  config.environment = ENV['AVATAX_ENVIRONMENT'].presence || (Rails.env.production? ? :production : :sandbox)
  config.log = true
  config.log_to_stdout = false
  config.address_validation = true
  config.address_validation_enabled_countries = ['United States', 'Canada']
  config.tax_calculation = true
  config.document_commit = true
  # The origin MUST be a JSON string. An example is shown below:
  # { line1: '915 S Jackson St', line2: '', city: 'Montgomery', region: 'AL', postalCode: 36104, country: 'US' }.to_json
  config.origin = '{}'
  config.refuse_checkout_address_validation_error = false
  config.customer_can_validate = false
  config.raise_exceptions = false 
end
```

### 3. Seed the DB

Then, load all seeds:

```console
$ bundle exec rake solidus_avatax_certified:load_seeds
```

The line above will:

- Create the entity use codes given to us by Avalara
- Destroy the _Default_ tax category
- Create the _Clothing_ and _Shipping_ tax categories
- Add the _Shipping_ tax category to all shipping methods
- Add the _Clothing_ tax category to all products
- Destroy the _North America_ tax rate
- Create tax rates for _Clothing_ and _Shipping_
- Populate the default stock location with a random address

You can also run the following if you only want to load Avalara entity use codes:

```console
$ bundle exec rake solidus_avatax_certified:load_use_codes
```

### 4. Adjust your tax categories

AvaTax has a list of [tax codes](https://taxcode.avatax.avalara.com/). You should create a tax
category for each tax code used by your store.

The `solidus_avatax_certified:load_seeds` tax creates two tax categories: _Clothing_ and _Shipping_.
We invite you to check that the tax categories make sense for your store and that they have the
appropriate tax codes.

If you need to adjust the tax categories or create new ones, the process is:

1. Create a new tax category, using the appropriate tax code
2. Create a tax rate for the tax category, use 0.0 as the rate and the _Spree/Avalara Transaction_
   calculator
3. Assign products (or shipping methods) to the tax category

## Usage

solidus_avatax_certified will automatically calculate sales taxes for any products that belong to
an AvaTax-backed tax category.

### Assigning entity use codes to users

If any of your clients require a special entity use code, you can assign it to them from their
profile page in the Solidus backend.

## Testing

To run the tests, install the bundle and run `rake`, which will generate a test app and run all
tests against it:

```console
$ bundle
$ bundle exec rake
```

## License

Copyright (c) 2016-∞ Boomer Digital LLC, released under the New BSD License.
