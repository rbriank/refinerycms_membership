# class RefinerycmsMemberships < Refinery::Generators::EngineInstaller
#
#   source_root File.expand_path('../../../', __FILE__)
#   engine_name "memberships"
#
# end


module Refinery
  class MembershipsGenerator < Rails::Generators::Base

    def rake_db
      rake("refinery_memberships:install:migrations")
    end

    def append_load_seed_data
      create_file 'db/seeds.rb' unless File.exists?(File.join(destination_root, 'db', 'seeds.rb'))
      append_file 'db/seeds.rb', :verbose => true do
        <<-EOH

# Added by Refinery CMS Blog engine
Refinery::Memberships::Engine.load_seed
        EOH
      end
    end

  end
end
