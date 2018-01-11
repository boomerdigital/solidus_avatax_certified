[![Build Status](https://travis-ci.org/boomerdigital/solidus_avatax_certified.svg?branch=master)](https://travis-ci.org/boomerdigital/solidus_avatax_certified)

SolidusAvataxCertified
===========

SolidusAvataxCertified is the *only* [officially certified Avatax solution](http://www.avalara.com/avalara-certified/) that integrates with Solidus.  With this extension you can add instantaneous sales tax decisions to your store.

From Avalara's own explanation of the certification program:

> Relax. It’s certified.
>
> Our “Certified for AvaTax” Program features integrations that perform at the highest level, providing the best possible customer experience.

> Avalara’s partners who have created certified integrations for AvaTax have demonstrated that those integrations contain elements which are essential to providing customers with easy-to-use software that gives accurate sales tax calculations. The certification criteria used to demonstrate these elements are based on Avalara’s years of experience integrating into ERP, ecommerce and point-of-sale applications.

**[For Installation and Setup instructions, please visit our wiki.](https://github.com/boomerdigital/solidus_avatax_certified/wiki)**

Version Compatibility Chart
---------------------------

| Solidus Version | Avatax Branch | Latest Avatax Version |
|:---------------:|:-------------:|:---------------------:|
|   v1.0 - v2.0   |   v1.0-v2.0   |         1.1.0         |
|   v2.1 - v2.2   |    v2.1-2.2   |         2.0.0         |
|   v2.3 - master |     master    |         3.0.0         |


Testing
-------

Be sure to bundle your dependencies and then create a dummy test app for the specs to run against.

    $ bundle
    $ bundle exec rake test_app
    $ bundle exec rspec spec

Copyright (c) 2016 Boomer Digital LLC, released under the New BSD License

