spree-aftership
==============

Introduction goes here.

Installation
============

###1. Add the following line to your application's Gemfile

     gem "spree_paypal_express", :git => "git://github.com/spree/spree_paypal_express.git"

**Note:** The :git option is only required for the edge version, and can be removed to used the released gem.

###2. Run bundler

      bundle install

###3. Copy assets / migrations

      rails g spree_paypal_express:install

Configuration
=============
###1. Before you begin

You'll need to have a Paypal developer account (developer.paypal.com) and both buyer and seller test accounts.

**Tip:** these are sandbox only, so use email addresses and passwords that are easy to  remember, e.g. buyer@example.com and seller@example.com.

Your sandbox credentials are available from the API Credentials link.

###2. Setup the Payment Method

Log in as an admin and add a new **Payment Method** (under Configuration), using following details:

**Name:** Paypal Express

**Environment:** Development (or what ever environment you prefer)

**Active:** Yes

**Provider:** Spree::BillingIntegration::PaypalExpress

Click **Create* , and now add your credentials in the screen that follows:

**Review:** unchecked [1]

**Signature:** API signature from your paypal seller test account

**Server:** test (for Development or live for Production)

**Test Mode:** checked (or unchecked for Production)

**Password:** API Password from your paypal seller test account

**Login:** API Username from your paypal seller test account (care to use the API Username and not the Test Account address)

Click **Update**

Copyright (c) 2012 [name of extension creator], released under the New BSD License
