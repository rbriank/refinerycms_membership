module Refinery
  module Memberships
    class Engine < Rails::Engine
      include Refinery::Engine
      isolate_namespace Refinery::Memberships


      initializer "static assets" do |app|
        app.middleware.insert_after ::ActionDispatch::Static, ::ActionDispatch::Static, "#{root}/public"
      end

      initializer "register refinerycms_memberships plugin" do
        Refinery::Plugin.register do |plugin|
          plugin.pathname = root
          plugin.name = "refinerycms_memberships"
          plugin.url = proc { Refinery::Core::Engine.routes.url_helpers.memberships_admin_members_path }
          plugin.menu_match = /refinery\/memberships/
        end

        # permissions tab on page editor
        ::Refinery::Pages::Tab.register do |tab|
          tab.name = "Access restrictions"
          tab.partial = "/refinery/pages/admin/tabs/roles"
        end
      end

      refinery.after_inclusion do
        ::Devise.setup do | config |
          config.mailer = '::Refinery::Memberships::MembershipMailer'
        end

        require File.expand_path('../../../rails_datatables/rails_datatables', __FILE__)
        ActionView::Base.send :include, RailsDatatables


        require 'memberships/warden_failure'

        # render the right page on login
        ::Devise.setup do |config|
          config.warden do |manager|
            manager.failure_app = Memberships::WardenFailure
          end
        end

      end # refinery.after_inclusion
    end # Engine < Rails::Engine
  end # Memberships
end # Refinery
