module Spree
  class AftershipConfiguration < Preferences::Configuration
    preference :consumer_key, :string, :default => ""
    preference :consumer_secret, :string, :default => ""
  end
end