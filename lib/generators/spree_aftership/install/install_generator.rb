module SpreeAftership
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def copy_initializers
        copy_file "aftership.rb", "config/initializers/aftership.rb"
      end

    end
  end
end