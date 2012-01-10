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
          plugin.menu_match = /(refinery|admin)\/(memberships|members|membership_emails|membership_email_parts|roles)$/
        end
        
        # permissions tap on page editor
        ::Refinery::Pages::Tab.register do |tab|
          tab.name = "Access restrictions"
          tab.partial = "/admin/pages/tabs/roles"
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

      refinery.after_inclusion do
        require File.expand_path('../rails_datatables/rails_datatables', __FILE__)
        ActionView::Base.send :include, RailsDatatables
        
        # make users and members two different classes
        User.class_eval do
          set_inheritance_column :membership_level
        end
    
        
        Role.class_eval do
          has_and_belongs_to_many :pages
        end
        
        #redirect user to the right page after login
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
                # restricted pages must be available for admins
                (roles & user.roles).any? || user.has_role?('Refinery') || user.has_role?('Superuser')

              end
            end
          end
        end # Page.class_eval
        
        
        # validations and pagination
        Role.class_eval do          
          validates_presence_of :title
          acts_as_indexed :fields => [:title]
          # Number of settings to show per page when using will_paginate
          def self.per_page
            12
          end
        end

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
              # redirect to the right login page...
              redirect_to login_members_path(:redirect => request.fullpath, :member_login => true)
            end
          end
        end # PagesController.class_eval
        
        # show only admins in Users administration
        ::Admin::UsersController.class_eval do
          def render(*args)
            @users.reject!{|u|u.is_a?(Member)} if @users
            super
          end
        end
        
        require 'memberships/warden_failure'
        
        # render the right page on login      
        ::Devise.setup do |config|
          config.warden do |manager|
            manager.failure_app = Refinery::Memberships::WardenFailure
          end
        end
        
      end # config.to_prepare
    end # Engine < Rails::Engine
  end # Memberships
end # Refinery
