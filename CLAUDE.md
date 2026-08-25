# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Run all tests (generates dummy app on first run)
bundle exec rake

# Run a single spec file
bundle exec rspec spec/models/spree/avalara_transaction_spec.rb

# Run a single example by line number
bundle exec rspec spec/models/spree/avalara_transaction_spec.rb:42

# Regenerate the dummy app (needed after engine changes)
bin/rake extension:test_app

# Seed the database (entity use codes, tax categories, tax rates)
bundle exec rake solidus_avatax_certified:load_seeds

# Seed only entity use codes
bundle exec rake solidus_avatax_certified:load_use_codes
```

## Architecture

This is a **Solidus Rails engine** (`SolidusAvataxCertified::Engine`) that integrates with Avalara's AvaTax REST API. It extends Solidus by decorating existing Spree models and plugging into the Solidus tax calculation pipeline.

### Tax Calculation Flow

Tax is calculated at checkout (payment step onward), not earlier. The entry point is the custom calculator:

1. **`Spree::Calculator::AvalaraTransaction`** (`app/models/spree/calculator/avalara_transaction.rb`) — Solidus calls `compute_line_item` / `compute_shipment` on this calculator for each taxable item. It skips early checkout states (`cart`, `address`, `delivery`) and caches the full AvaTax response per order.

2. The calculator calls `order.avalara_capture` or `order.avalara_capture_finalize` (depending on whether the order can be finalized), which are methods added to `Spree::Order` via a decorator.

3. **`Spree::AvalaraTransaction`** (`app/models/spree/avalara_transaction.rb`) — An ActiveRecord model with a one-to-one relationship to `Spree::Order`. It orchestrates the three API actions: `lookup_avatax` (estimate), `commit_avatax` (SalesOrder/ReturnOrder), and `commit_avatax_final` (SalesInvoice/ReturnInvoice).

4. **`TaxSvc`** (`app/models/tax_svc.rb`) — Wraps the `AvaTax::Client` (the official `avatax` gem). All HTTP calls to AvaTax go through here. Responses are wrapped in `SolidusAvataxCertified::Response::*` objects.

5. **`SolidusAvataxCertified::Request::GetTax` / `ReturnTax`** — Build the request hash sent to AvaTax. Both inherit from `Request::Base`, which assembles address lines and sales lines via `SolidusAvataxCertified::Address` and `SolidusAvataxCertified::Line`.

### How Solidus Models Are Extended

Decorators live in `app/decorators/` and use `prepend` to inject behavior into Solidus core models without reopening classes. The engine loads them in `config.to_prepare` (important: runs on every request in development).

Key decorators:
- **`OrderDecorator`** — adds `has_one :avalara_transaction`, hooks into the order state machine (`before_transition to: :canceled` → `cancel_avalara`; `before_transition to: :delivery` → `validate_ship_address`), and adds `avalara_capture` / `avalara_capture_finalize`.
- Other decorators add `avatax_cache_key` and `avatax_line_code` helpers to line items, shipments, adjustments, etc., used by the calculator's cache-key logic.

### Configuration

`Spree::Avatax::Config` is a `Spree::AvataxConfiguration` preference object initialized in `lib/spree/avatax/config.rb`. Configure via `config/initializers/avatax.rb` or ENV vars:

- `AVATAX_COMPANY_CODE`, `AVATAX_LICENSE_KEY`, `AVATAX_ACCOUNT`, `AVATAX_ENVIRONMENT`

Feature flags on the config object (`tax_calculation`, `document_commit`, `address_validation`) gate every API call; checking them before making assumptions about behavior.

### Address Validation

`SolidusAvataxCertified::Address` wraps the order's ship/origin addresses and calls `TaxSvc#validate_address`. The `OrderDecorator` state machine hook triggers this when transitioning to the `delivery` state. The `refuse_checkout_address_validation_error` config flag controls whether a validation failure blocks checkout.

### Testing

- Tests use **VCR** (cassettes in `spec/vcr/`) to record and replay AvaTax HTTP interactions. Cassettes match on HTTP method only (`match_requests_on: [:method]`).
- Feature specs use **Cuprite** (Chrome DevTools Protocol driver).
- Factory Bot factories are in `lib/solidus_avatax_certified/testing_support/factories/`.
- The dummy Rails app is auto-generated into `spec/dummy/` via `bin/rake extension:test_app`. Delete this directory and re-run if the app gets into a broken state.
- Live API credentials can be set via ENV vars for recording new VCR cassettes (see `spec/support/avatax_config_preferences.rb`).
