module Spree
  class AftershipConfiguration < Preferences::Configuration
    preference :api_key, :string, :default => ""
  end
end