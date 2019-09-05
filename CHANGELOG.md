# Change Log

## [Unreleased](https://github.com/boomerdigital/solidus_avatax_certified/tree/HEAD)

[Full Changelog](https://github.com/boomerdigital/solidus_avatax_certified/compare/v2.1.1...HEAD)

**Closed issues:**

- Remove PreferenceSeeder [\#133](https://github.com/boomerdigital/solidus_avatax_certified/issues/133)
- Remove preferences form [\#123](https://github.com/boomerdigital/solidus_avatax_certified/issues/123)
- Make environment configurable w/o environment variable [\#122](https://github.com/boomerdigital/solidus_avatax_certified/issues/122)
- Merge setup.md and readme.md? [\#118](https://github.com/boomerdigital/solidus_avatax_certified/issues/118)
- Discount doesn't take manual adjustments into account [\#112](https://github.com/boomerdigital/solidus_avatax_certified/issues/112)
- VCR cassettes not up to date [\#108](https://github.com/boomerdigital/solidus_avatax_certified/issues/108)
- Shipment Discounts Double Counted in Solidus 2.4 [\#107](https://github.com/boomerdigital/solidus_avatax_certified/issues/107)
- Incorrect country title [\#97](https://github.com/boomerdigital/solidus_avatax_certified/issues/97)
- avalara\_response\[:totalTax\] is always nil [\#96](https://github.com/boomerdigital/solidus_avatax_certified/issues/96)
- All Preferences lost when server restarts [\#95](https://github.com/boomerdigital/solidus_avatax_certified/issues/95)
- Sandbox documentation warning [\#94](https://github.com/boomerdigital/solidus_avatax_certified/issues/94)
- Ruby 2.3 syntax [\#82](https://github.com/boomerdigital/solidus_avatax_certified/issues/82)
- Capybara::Poltergeist::JavascriptError \(TypeError: undefined is not a function\) [\#81](https://github.com/boomerdigital/solidus_avatax_certified/issues/81)
- Updating preferences only updates them on the current server [\#77](https://github.com/boomerdigital/solidus_avatax_certified/issues/77)
- Adjust Locked Transaction Error [\#75](https://github.com/boomerdigital/solidus_avatax_certified/issues/75)
- Universal Branch [\#66](https://github.com/boomerdigital/solidus_avatax_certified/issues/66)
- Errors Being Ignored [\#53](https://github.com/boomerdigital/solidus_avatax_certified/issues/53)

**Merged pull requests:**

- Update VCR cassettes [\#140](https://github.com/boomerdigital/solidus_avatax_certified/pull/140) ([aldesantis](https://github.com/aldesantis))
- Bump RSpec to 4.0.0.beta2 for Rails 6 support [\#139](https://github.com/boomerdigital/solidus_avatax_certified/pull/139) ([aldesantis](https://github.com/aldesantis))
- Require deface 1.5 [\#138](https://github.com/boomerdigital/solidus_avatax_certified/pull/138) ([DanielePalombo](https://github.com/DanielePalombo))
- Evaluate specific solidus branches in CI [\#137](https://github.com/boomerdigital/solidus_avatax_certified/pull/137) ([cedum](https://github.com/cedum))
- Remove preferences edit form [\#136](https://github.com/boomerdigital/solidus_avatax_certified/pull/136) ([cedum](https://github.com/cedum))
- Deprecate preference seeder [\#135](https://github.com/boomerdigital/solidus_avatax_certified/pull/135) ([cedum](https://github.com/cedum))
- Remove dotenv dependency [\#134](https://github.com/boomerdigital/solidus_avatax_certified/pull/134) ([cedum](https://github.com/cedum))
- Fix Travis builds [\#132](https://github.com/boomerdigital/solidus_avatax_certified/pull/132) ([aldesantis](https://github.com/aldesantis))
- Fix typos in some decorators module names [\#131](https://github.com/boomerdigital/solidus_avatax_certified/pull/131) ([cedum](https://github.com/cedum))
- Make environment configurable w/o an ENV variable [\#130](https://github.com/boomerdigital/solidus_avatax_certified/pull/130) ([cedum](https://github.com/cedum))
- Use Module\#prepend for decorators [\#129](https://github.com/boomerdigital/solidus_avatax_certified/pull/129) ([aldesantis](https://github.com/aldesantis))
- Remove stylesheets [\#128](https://github.com/boomerdigital/solidus_avatax_certified/pull/128) ([aldesantis](https://github.com/aldesantis))
- Discounts bugfixes [\#125](https://github.com/boomerdigital/solidus_avatax_certified/pull/125) ([aldesantis](https://github.com/aldesantis))
- Fix adjustments not being considered for cache key [\#124](https://github.com/boomerdigital/solidus_avatax_certified/pull/124) ([aldesantis](https://github.com/aldesantis))
- Fix 'superclass mismatch for Order' [\#120](https://github.com/boomerdigital/solidus_avatax_certified/pull/120) ([aldesantis](https://github.com/aldesantis))
- Remove setup instruction file since we use the wiki now [\#119](https://github.com/boomerdigital/solidus_avatax_certified/pull/119) ([acreilly](https://github.com/acreilly))
- Upgrade Ruby to 2.6.2 [\#117](https://github.com/boomerdigital/solidus_avatax_certified/pull/117) ([aldesantis](https://github.com/aldesantis))
- Rubocop [\#116](https://github.com/boomerdigital/solidus_avatax_certified/pull/116) ([aldesantis](https://github.com/aldesantis))
- Add .bundler to .gitignore [\#115](https://github.com/boomerdigital/solidus_avatax_certified/pull/115) ([aldesantis](https://github.com/aldesantis))
- Take manual adjustments into account when computing discount [\#114](https://github.com/boomerdigital/solidus_avatax_certified/pull/114) ([aldesantis](https://github.com/aldesantis))
- Fix deprecation warnings [\#113](https://github.com/boomerdigital/solidus_avatax_certified/pull/113) ([acreilly](https://github.com/acreilly))
- Vcr update [\#111](https://github.com/boomerdigital/solidus_avatax_certified/pull/111) ([acreilly](https://github.com/acreilly))
- Travis specs [\#110](https://github.com/boomerdigital/solidus_avatax_certified/pull/110) ([acreilly](https://github.com/acreilly))
- 2.7 [\#104](https://github.com/boomerdigital/solidus_avatax_certified/pull/104) ([acreilly](https://github.com/acreilly))
- Return true if shipment promo\_total is not zero [\#103](https://github.com/boomerdigital/solidus_avatax_certified/pull/103) ([acreilly](https://github.com/acreilly))
- Add new versions of Solidus to travis [\#98](https://github.com/boomerdigital/solidus_avatax_certified/pull/98) ([acreilly](https://github.com/acreilly))

## [v2.1.1](https://github.com/boomerdigital/solidus_avatax_certified/tree/v2.1.1) (2018-01-15)
[Full Changelog](https://github.com/boomerdigital/solidus_avatax_certified/compare/v1.2.1...v2.1.1)

## [v1.2.1](https://github.com/boomerdigital/solidus_avatax_certified/tree/v1.2.1) (2018-01-15)
[Full Changelog](https://github.com/boomerdigital/solidus_avatax_certified/compare/v3.1.0...v1.2.1)

**Closed issues:**

- Solidus 2.4 Support [\#89](https://github.com/boomerdigital/solidus_avatax_certified/issues/89)

**Merged pull requests:**

- V2.1 v2.2 spec pass updates [\#93](https://github.com/boomerdigital/solidus_avatax_certified/pull/93) ([acreilly](https://github.com/acreilly))
- V1.0 v2.0 spec pass updates [\#92](https://github.com/boomerdigital/solidus_avatax_certified/pull/92) ([acreilly](https://github.com/acreilly))
- Specify pg gem version [\#91](https://github.com/boomerdigital/solidus_avatax_certified/pull/91) ([acreilly](https://github.com/acreilly))
- Update Compatibility Chart [\#90](https://github.com/boomerdigital/solidus_avatax_certified/pull/90) ([acreilly](https://github.com/acreilly))
- Refactor address validator [\#83](https://github.com/boomerdigital/solidus_avatax_certified/pull/83) ([acreilly](https://github.com/acreilly))

## [v3.1.0](https://github.com/boomerdigital/solidus_avatax_certified/tree/v3.1.0) (2017-08-03)
[Full Changelog](https://github.com/boomerdigital/solidus_avatax_certified/compare/v2.1.0...v3.1.0)

## [v2.1.0](https://github.com/boomerdigital/solidus_avatax_certified/tree/v2.1.0) (2017-08-03)
[Full Changelog](https://github.com/boomerdigital/solidus_avatax_certified/compare/v1.2.0...v2.1.0)

## [v1.2.0](https://github.com/boomerdigital/solidus_avatax_certified/tree/v1.2.0) (2017-08-03)
[Full Changelog](https://github.com/boomerdigital/solidus_avatax_certified/compare/v3.0.0...v1.2.0)

**Closed issues:**

- Error in \#tax\_included\_in\_price? [\#76](https://github.com/boomerdigital/solidus_avatax_certified/issues/76)
- Avatax REST API V2 [\#58](https://github.com/boomerdigital/solidus_avatax_certified/issues/58)

**Merged pull requests:**

- Rest v2 avatax create transaction [\#74](https://github.com/boomerdigital/solidus_avatax_certified/pull/74) ([acreilly](https://github.com/acreilly))
- Set up Void action to use new V2 REST API endpoint [\#73](https://github.com/boomerdigital/solidus_avatax_certified/pull/73) ([acreilly](https://github.com/acreilly))

## [v3.0.0](https://github.com/boomerdigital/solidus_avatax_certified/tree/v3.0.0) (2017-05-31)
[Full Changelog](https://github.com/boomerdigital/solidus_avatax_certified/compare/v2.0.0...v3.0.0)

**Merged pull requests:**

- Rest v2 avatax ping [\#72](https://github.com/boomerdigital/solidus_avatax_certified/pull/72) ([acreilly](https://github.com/acreilly))

## [v2.0.0](https://github.com/boomerdigital/solidus_avatax_certified/tree/v2.0.0) (2017-05-25)
[Full Changelog](https://github.com/boomerdigital/solidus_avatax_certified/compare/v1.1.0...v2.0.0)

## [v1.1.0](https://github.com/boomerdigital/solidus_avatax_certified/tree/v1.1.0) (2017-05-25)
[Full Changelog](https://github.com/boomerdigital/solidus_avatax_certified/compare/v1.0.0...v1.1.0)

**Closed issues:**

- Preferences [\#65](https://github.com/boomerdigital/solidus_avatax_certified/issues/65)
- response object is nil in address validation [\#64](https://github.com/boomerdigital/solidus_avatax_certified/issues/64)
- Support Solidus 2.1 [\#63](https://github.com/boomerdigital/solidus_avatax_certified/issues/63)
- Multiple Payments [\#51](https://github.com/boomerdigital/solidus_avatax_certified/issues/51)
- Previous Versions No Longer Available [\#50](https://github.com/boomerdigital/solidus_avatax_certified/issues/50)

**Merged pull requests:**

- Rest v2 avatax address [\#71](https://github.com/boomerdigital/solidus_avatax_certified/pull/71) ([acreilly](https://github.com/acreilly))
- If a timeout occurs, the address validator will respond with an error… [\#70](https://github.com/boomerdigital/solidus_avatax_certified/pull/70) ([acreilly](https://github.com/acreilly))
- V2.1 travis [\#69](https://github.com/boomerdigital/solidus_avatax_certified/pull/69) ([acreilly](https://github.com/acreilly))
- Travis 2.0 below [\#68](https://github.com/boomerdigital/solidus_avatax_certified/pull/68) ([acreilly](https://github.com/acreilly))
- Utilize Spree::Preferences to hold avatax information. [\#67](https://github.com/boomerdigital/solidus_avatax_certified/pull/67) ([acreilly](https://github.com/acreilly))
- Improve errors [\#62](https://github.com/boomerdigital/solidus_avatax_certified/pull/62) ([acreilly](https://github.com/acreilly))
- Remove payment amount update [\#61](https://github.com/boomerdigital/solidus_avatax_certified/pull/61) ([acreilly](https://github.com/acreilly))
- Remove payment amount update and add spec [\#60](https://github.com/boomerdigital/solidus_avatax_certified/pull/60) ([acreilly](https://github.com/acreilly))
- Improve error handling [\#59](https://github.com/boomerdigital/solidus_avatax_certified/pull/59) ([acreilly](https://github.com/acreilly))
- Request model [\#57](https://github.com/boomerdigital/solidus_avatax_certified/pull/57) ([acreilly](https://github.com/acreilly))
- Response model [\#56](https://github.com/boomerdigital/solidus_avatax_certified/pull/56) ([acreilly](https://github.com/acreilly))
- Refactored Logger [\#55](https://github.com/boomerdigital/solidus_avatax_certified/pull/55) ([acreilly](https://github.com/acreilly))

## [v1.0.0](https://github.com/boomerdigital/solidus_avatax_certified/tree/v1.0.0) (2017-03-27)
**Closed issues:**

- Previous Tax Amount when recalculated to 0 [\#43](https://github.com/boomerdigital/solidus_avatax_certified/issues/43)
- Single Version [\#35](https://github.com/boomerdigital/solidus_avatax_certified/issues/35)
- AvataxLog doesn't have an error method [\#33](https://github.com/boomerdigital/solidus_avatax_certified/issues/33)
- Remove prev\_tax return if state check [\#31](https://github.com/boomerdigital/solidus_avatax_certified/issues/31)
- Solidus 2.0 and Rails 5 [\#29](https://github.com/boomerdigital/solidus_avatax_certified/issues/29)
- Can't edit credentials in Admin without an Address [\#20](https://github.com/boomerdigital/solidus_avatax_certified/issues/20)
- Javascript not formatted correctly [\#19](https://github.com/boomerdigital/solidus_avatax_certified/issues/19)
- 1.3 Progress? [\#14](https://github.com/boomerdigital/solidus_avatax_certified/issues/14)

**Merged pull requests:**

- Clean vcr [\#47](https://github.com/boomerdigital/solidus_avatax_certified/pull/47) ([acreilly](https://github.com/acreilly))
- Spec speed improvements [\#46](https://github.com/boomerdigital/solidus_avatax_certified/pull/46) ([acreilly](https://github.com/acreilly))
- Rails test param backport [\#45](https://github.com/boomerdigital/solidus_avatax_certified/pull/45) ([acreilly](https://github.com/acreilly))
- Return 0 if avalara total tax is 0 [\#44](https://github.com/boomerdigital/solidus_avatax_certified/pull/44) ([acreilly](https://github.com/acreilly))
- Universal specs [\#42](https://github.com/boomerdigital/solidus_avatax_certified/pull/42) ([acreilly](https://github.com/acreilly))
- Vcr [\#41](https://github.com/boomerdigital/solidus_avatax_certified/pull/41) ([acreilly](https://github.com/acreilly))
- 2.1 [\#38](https://github.com/boomerdigital/solidus_avatax_certified/pull/38) ([acreilly](https://github.com/acreilly))
- Added timeouts to all http calls [\#37](https://github.com/boomerdigital/solidus_avatax_certified/pull/37) ([ericsaupe](https://github.com/ericsaupe))
- V1.3 and up [\#36](https://github.com/boomerdigital/solidus_avatax_certified/pull/36) ([acreilly](https://github.com/acreilly))
- Error message [\#34](https://github.com/boomerdigital/solidus_avatax_certified/pull/34) ([ericsaupe](https://github.com/ericsaupe))
- Include blank on avalara entity use code select [\#30](https://github.com/boomerdigital/solidus_avatax_certified/pull/30) ([acreilly](https://github.com/acreilly))
- V1.2 js refactor [\#28](https://github.com/boomerdigital/solidus_avatax_certified/pull/28) ([acreilly](https://github.com/acreilly))
- V1.3 [\#27](https://github.com/boomerdigital/solidus_avatax_certified/pull/27) ([acreilly](https://github.com/acreilly))
- Set country fallback if origin country is nil [\#25](https://github.com/boomerdigital/solidus_avatax_certified/pull/25) ([acreilly](https://github.com/acreilly))
- Set country fallback if origin country is nil [\#24](https://github.com/boomerdigital/solidus_avatax_certified/pull/24) ([acreilly](https://github.com/acreilly))
- V1.3 js refactor [\#23](https://github.com/boomerdigital/solidus_avatax_certified/pull/23) ([acreilly](https://github.com/acreilly))
- Remove deface override, create validator button partial, and add it t… [\#22](https://github.com/boomerdigital/solidus_avatax_certified/pull/22) ([acreilly](https://github.com/acreilly))
- Remove deface override, create validator button partial, and add it t… [\#21](https://github.com/boomerdigital/solidus_avatax_certified/pull/21) ([acreilly](https://github.com/acreilly))
- V1.2 [\#17](https://github.com/boomerdigital/solidus_avatax_certified/pull/17) ([acreilly](https://github.com/acreilly))
- V1.3 [\#16](https://github.com/boomerdigital/solidus_avatax_certified/pull/16) ([acreilly](https://github.com/acreilly))
- V1.2 [\#15](https://github.com/boomerdigital/solidus_avatax_certified/pull/15) ([acreilly](https://github.com/acreilly))
- V1.2 [\#13](https://github.com/boomerdigital/solidus_avatax_certified/pull/13) ([acreilly](https://github.com/acreilly))
- V1.2 vat spec [\#12](https://github.com/boomerdigital/solidus_avatax_certified/pull/12) ([acreilly](https://github.com/acreilly))
- V1.2 fix enable avatax [\#11](https://github.com/boomerdigital/solidus_avatax_certified/pull/11) ([acreilly](https://github.com/acreilly))
- added vat id no [\#10](https://github.com/boomerdigital/solidus_avatax_certified/pull/10) ([acreilly](https://github.com/acreilly))
- V1.2 address validator [\#9](https://github.com/boomerdigital/solidus_avatax_certified/pull/9) ([acreilly](https://github.com/acreilly))
- fixed user update page [\#8](https://github.com/boomerdigital/solidus_avatax_certified/pull/8) ([acreilly](https://github.com/acreilly))
- fixed user update page [\#7](https://github.com/boomerdigital/solidus_avatax_certified/pull/7) ([acreilly](https://github.com/acreilly))
- fixed preference updater for env [\#5](https://github.com/boomerdigital/solidus_avatax_certified/pull/5) ([acreilly](https://github.com/acreilly))
- V1.2 address validation [\#3](https://github.com/boomerdigital/solidus_avatax_certified/pull/3) ([acreilly](https://github.com/acreilly))
- new avatax client version [\#2](https://github.com/boomerdigital/solidus_avatax_certified/pull/2) ([acreilly](https://github.com/acreilly))
- V1.2 [\#1](https://github.com/boomerdigital/solidus_avatax_certified/pull/1) ([acreilly](https://github.com/acreilly))



\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*