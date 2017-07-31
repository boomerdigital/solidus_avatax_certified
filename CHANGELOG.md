## SolidusAvataxCertified v3.0.0 (SOLIDUS VERSIONS 2.3)

- See https://github.com/boomerdigital/solidus_avatax_certified/releases/tag/v3.0.0


## SolidusAvataxCertified v2.0.0 (SOLIDUS VERSIONS 2.1-2.2)

- Include Soldus' new TaxHelpers and utilize the new TaxHelper methods.

- Use Order#tax_address

- Do not calculate tax until after delivery step.

- Create SolidusAvataxCertified::OrderAdjuster to be the Spree::Config.tax_adjuster_class.


## SolidusAvataxCertified v1.1.0 (SOLIDUS VERSIONS 1.0-2.0)

- Replace CircleCI with TravisCI

- Refactor Logger. Improve Logger to only log to one file rather than multiple. Reduce amount of logging.

- Remove Spree::AvalaraPreference and use Spree::Avatax::Config utilizing preference store.

- Create Request models to handle formatting requests sent to Avatax API.

- Create Response models to handle the response Avatax API returns.

- Remove not_tax scope and use Solidus' non_tax scope.

- Add preference to enable raising exceptions.

- Create custom errors.

- Create version file.


## SolidusAvataxCertified v1.0.0

See https://github.com/boomerdigital/solidus_avatax_certified/releases/tag/v1.0.0
