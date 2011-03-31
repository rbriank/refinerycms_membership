require 'refinerycms-base'
require 'refinerycms-dashboard'

module Refinery
  module Memberships
    class Engine < Rails::Engine
      initializer "static assets" do |app|
        app.middleware.insert_after ::ActionDispatch::Static, ::ActionDispatch::Static, "#{root}/public"
      end

      config.after_initialize do
        Refinery::Plugin.register do |plugin|
          plugin.name = "memberships"
          plugin.menu_match = /(refinery|admin)\/(memberships)?(page_roles)?(user_roles)?$/
        end

        # this broke as part of config.to_prepare
        # Do this or lost password non-admins still goes to the dashboard
        ::Admin::DashboardController.class_eval do
          old_index = instance_method(:index)
          define_method(:index){|*args|
            if current_user.has_role?(:super_user) || current_user.has_role?(:refinery)
              old_index.bind(self).call(*args)
            else
              redirect_to '/'
            end
          }
        end # Admin::DashboardController.class_eval
      end # config.after_initialize

      refinery.on_attach do
        require File.expand_path('../rails_datatables/rails_datatables', __FILE__)
        ActionView::Base.send :include, RailsDatatables

        Role.class_eval do
          has_and_belongs_to_many :pages
        end
        
        ApplicationController.class_eval do
          protected
          def after_sign_in_path_for(resource_or_scope)
            
            if resource_or_scope.class.superclass.name == 'User' || 
              resource_or_scope.class.name == 'User' ||
              resource_or_scope.to_s == 'user'
              if params[:redirect].present?
                params[:redirect]
              else
                if !resource_or_scope.is_a?(Symbol) && (resource_or_scope.has_role?('Superuser')||resource_or_scope.has_role?('Refinery'))
                  super
                else
                  '/'
                end
              end
            else
              super
            end
          end
        end

        Page.class_eval do
          has_and_belongs_to_many :roles

          def user_allowed?(user)
            # if a page has no roles assigned, let everyone see it
            if roles.blank?
              true

            else
              # if a page has roles, but the user doesn't or is nil
              if user.nil? || user.roles.blank?
                false

              # otherwise, check user vs. page roles
              else
                (roles & user.roles).any? || user.has_role?('Refinery') || user.has_role?('Superuser')

              end
            end
          end
        end # Page.class_eval

        PagesController.class_eval do
          def show
            # Find the page by the newer 'path' or fallback to the page's id if no path.
            @page = Page.find(params[:path] ? params[:path].to_s.split('/').last : params[:id],
              :include => :roles)

            if @page.user_allowed?(current_user) &&
              (@page.try(:live?) ||
                  (refinery_user? and current_user.authorized_plugins.include?("refinery_pages")))

              # if the admin wants this to be a "placeholder" page which goes to its first child, go to that instead.
              if @page.skip_to_first_child and (first_live_child = @page.children.order('lft ASC').where(:draft=>false).first).present?
                redirect_to first_live_child.url
              end
            else
              redirect_to login_members_path(:redirect => request.request_uri)
            end
          end
        end # PagesController.class_eval
        
      end # config.to_prepare
    end # Engine < Rails::Engine
  end # Memberships
end # Refinery
