require 'refinerycms-core'
require 'refinerycms-dashboard'

module Refinery
  
  autoload :MembershipsGenerator, 'generators/refinery/memberships/memberships_generator'
   
  module Memberships
    require 'refinery/Memberships/configuration'
    
    module Provinces
      CODES = %w(AB BC MB NB NL NT NS NU ON PE QC SK YT --
        AK AL AR AS AZ CA CO CT DC DE FL FM GA GU HI IA ID
        IL IN KS KY LA MA ME MD MH MI MN MO MP MS MT NC ND
        NE NH NJ NM NV NY OH OK OR PA PR PW RI SC SD TN TX
        UT VI VT VA WA WI WV WY)
    end
    
    class << self
      attr_writer :root

      def root
        @root ||= Pathname.new(File.expand_path('../../../', __FILE__))
      end
    end
    
    class Engine < Rails::Engine
      include Refinery::Engine
      isolate_namespace Refinery::Memberships

      engine_name :refinery_memberships

      initializer "register refinerycms_memberships plugin" do
        Refinery::Plugin.register do |plugin|
          plugin.name = "memberships"
          #plugin.menu_match = /(refinery|admin)\/(memberships)?(page_roles)?(user_roles)?$/
          plugin.url = proc { Refinery::Core::Engine.routes.url_helpers.memberships_admin_memberships_path }
          plugin.pathname = root
          #plugin.activity = {:class_name => :'refinery/memberships/pages_roles'}
          
        end
      end # initializer
      config.after_initialize do
        Refinery.register_extension(Refinery::Memberships)

        # this broke as part of config.to_prepare
        # Do this or lost password non-admins still goes to the dashboard
        Refinery::Admin::DashboardController.class_eval do
          old_index = instance_method(:index)
          define_method(:index){|*args|
            if current_refinery_user.has_role?(:super_user) || current_refinery_user.has_role?(:refinery)
              old_index.bind(self).call(*args)
            else
              redirect_to '/'
            end
          }
        end # Admin::DashboardController.class_eval
      end # config.after_initialize

      config.to_prepare do
        require File.expand_path('../../rails_datatables/rails_datatables', __FILE__)
        ActionView::Base.send :include, RailsDatatables

        ::Refinery::Role.class_eval do
          has_and_belongs_to_many :pages, :class_name => '::Refinery::Page'
        end

        ::Refinery::Page.class_eval do
          has_and_belongs_to_many :roles, :class_name => '::Refinery::Role'

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
                (roles & user.roles).any?

              end
            end
          end
        end # Page.class_eval
        
        ::MEMBER_ROLE_ID = ::Refinery::Role.where(:title => 'Member').pluck(:id).first
        ::REFINERY_ROLE_ID = ::Refinery::Role.where(:title => 'Refinery').pluck(:id).first
        ::SUPERUSER_ROLE_ID = ::Refinery::Role.where(:title => 'Superuser').pluck(:id).first
      end # config.to_prepare

      after_inclusion do
        ::Refinery::PagesController.class_eval do
          def show
            # Find the page by the newer 'path' or fallback to the page's id if no path.
            @page = ::Refinery::Page.find(params[:path] ? params[:path].to_s.split('/').last : params[:id],
              :include => :roles)

            if @page.user_allowed?(current_refinery_user) &&
              (@page.try(:live?) ||
                  (refinery_user? and current_refinery_user.authorized_plugins.include?("refinery_pages")))

              # if the admin wants this to be a "placeholder" page which goes to its first child, go to that instead.
              if @page.skip_to_first_child and (first_live_child = @page.children.order('lft ASC').where(:draft=>false).first).present?
                redirect_to first_live_child.url
              end
            else
              store_location
              redirect_to refinery.send(::Refinery::Memberships.new_user_method_path)
            end
          end
        end # PagesController.class_eval
       end #refinery on attach

    end # Engine < Rails::Engine
  end # Memberships
end # Refinery