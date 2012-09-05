module Refinery
  class MembershipsGenerator < Rails::Generators::Base

    source_root File.expand_path('../templates', __FILE__)

    def generate_memberships_initializer
      template "config/initializers/refinery/memberships.rb.erb", File.join(destination_root, "config", "initializers", "refinery", "memberships.rb")
    end


    def rake_db
      rake("refinery_memberships:install:migrations")
    end
    
  end
end
