spree_aftership
==============

Spree Extension for AfterShip.

This extension helps merchant who using Spree to auto import tracking number to AfterShip.

About AfterShip
==============

AfterShip provides an automated way for online merchants to track packages and send their customers delivery status notifications. Customers no longer need to deal with tracking numbers and track packages on their own. With AfterShip, online merchants extend their customer service after the point of purchase by keeping their customers actively informed, while saving time and money by reducing customers’ questions about the status of their purchase delivery. 

Installation
============

###1. Add the following line to your application's Gemfile

     gem "spree_aftership", :git => "git://github.com/AfterShip/spree_aftership.git"

###2. Run bundler

      bundle install

###3. Copy initializer

      rails g spree_aftership:install

Configuration
=============
###1. Before you begin
  
You'll need to have a AfterShip account [http://www.aftership.com](http://www.aftership.com).

	

###2. Setup the API Key
  
You can retrieve your api key at [https://www.aftership.com/connect/spree](https://www.aftership.com/connect/spree), then copy the api key to config/initializers/aftership.rb

	Spree::Aftership::Config[:api_key] =  "YOUR_API_KEY"

Replace "YOUR_API_KEY" to your AfterShip api key.
	

---------------------------------------

Copyright (c) 2012 AfterShip Ltd. , released under the New BSD License
