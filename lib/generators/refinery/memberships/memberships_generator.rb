module Refinery
  class MembershipsGenerator < Rails::Generators::Base

    source_root File.expand_path('../templates', __FILE__)

    def generate_memberships_initializer
      template "config/initializers/refinery/memberships.rb.erb", File.join(destination_root, "config", "initializers", "refinery", "memberships.rb")
    end

    
    def append_load_seed_data
      create_file 'db/seeds.rb' unless File.exists?(File.join(destination_root, 'db', 'seeds.rb'))
      append_file 'db/seeds.rb', :verbose => true do
        <<-EOH

# Added by Refinery CMS Events extension
Refinery::Events::Engine.load_seed
        EOH
      end
    end

    def rake_db
      rake("refinery_memberships:install:migrations")
    end
    
  end
end
