# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_aftership'
  s.version     = '1.0.0'
  s.summary     = 'AfterShip Extension for Spree'
  s.description = 'Auto-update tracking number to AfterShip'
  s.required_ruby_version = '>= 1.8.7'

  s.author            = 'Dante Tsang'
  s.email             = 'dante@aftership.com'
  s.homepage          = 'http://www.aftership.com'

  #s.files         = `git ls-files`.split("\n")
  #s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '>= 1.1.0'
  s.add_dependency 'thor'

  s.add_development_dependency 'capybara', '1.0.1'
  s.add_development_dependency 'factory_girl'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails',  '~> 2.7'
  s.add_development_dependency 'sqlite3'
end
