module Spree::Aftership; end
module SpreeAftership
  class Engine < Rails::Engine
    engine_name 'spree_aftership'

    config.autoload_paths += %W(#{config.root}/lib)

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    initializer "spree.aftership.preferences", :before => :load_config_initializers do |app|
      Spree::Aftership::Config = Spree::AftershipConfiguration.new
    end


    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../../app/**/*_decorator*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    config.to_prepare &method(:activate).to_proc
  end
end
