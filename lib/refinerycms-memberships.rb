require 'refinery'

module Refinery
  module Memberships
    class Engine < Rails::Engine
      initializer "static assets" do |app|
        app.middleware.insert_after ::ActionDispatch::Static, ::ActionDispatch::Static, "#{root}/public"
      end

      config.after_initialize do
        Refinery::Plugin.register do |plugin|
          plugin.name = "memberships"
          plugin.activity = {:class => Membership}
          plugin.menu_match = /(refinery|admin)\/(memberships)?(page_roles)?(user_roles)?$/
        end
      end # config.after_initialize

      config.to_prepare do
        Role.class_eval{ has_and_belongs_to_many :pages }
        
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
                (roles & user.roles).any?
                
              end
            end

            # roles.blank? ? true : user.nil? ? false : roles.blank? || (roles & user.roles).any?
          end
        end

        PagesController.class_eval do
          def show
            # Find the page by the newer 'path' or fallback to the page's id if no path.
            @page = Page.find(params[:path] ? params[:path].to_s.split('/').last : params[:id])

            if @page.user_allowed?(current_user) &&
                (@page.try(:live?) ||
                  (refinery_user? and current_user.authorized_plugins.include?("refinery_pages")))

              # if the admin wants this to be a "placeholder" page which goes to its first child, go to that instead.
              if @page.skip_to_first_child and (first_live_child = @page.children.order('lft ASC').where(:draft=>false).first).present?
                redirect_to first_live_child.url
              end
            else
              error_404
            end

          end
        end # PagesController.class_eval
      end # config.to_prepare

    end # Engine < Rails::Engine
  end # Memberships
end # Refinery