module Refinery
  module Memberships
    def self.use_relative_model_naming?
      true
    end

    class Engine < Rails::Engine
      include Refinery::Engine

      engine_name :refinery_memberships

      initializer "register refinerycms_memberships plugin" do
        Refinery::Plugin.register do |plugin|
          plugin.pathname = root
          plugin.name = "refinerycms_memberships"
          plugin.url = proc { Refinery::Core::Engine.routes.url_helpers.admin_memberships_path }
          plugin.menu_match = /refinery\/memberships/
        end

        # permissions tab on page editor
        ::Refinery::Pages::Tab.register do |tab|
          tab.name = "Access restrictions"
          tab.partial = "/refinery/pages/admin/tabs/roles"
        end
      end

      after_inclusion do
        ::Devise.setup do | config |
          config.mailer = '::Refinery::Memberships::MembershipMailer'
        end

        require File.expand_path('../../../rails_datatables/rails_datatables', __FILE__)
        ActionView::Base.send :include, RailsDatatables

        Dir.glob(File.join(Refinery::Memberships.root, "app/decorators/**/*_decorator.rb")) do |c|
          Rails.application.config.cache_classes ? require(c) : load(c)
        end

        require 'memberships/warden_failure'

        # render the right page on login
        ::Devise.setup do |config|
          config.warden do |manager|
            manager.failure_app = Memberships::WardenFailure
          end
        end

      end # refinery.after_inclusion

      config.after_initialize do
        Refinery.register_engine(Refinery::Memberships)
      end

    end # Engine < Rails::Engine
  end # Memberships
end # Refinery
