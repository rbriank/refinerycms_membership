module Refinery
  module Memberships
    class WardenFailure < Devise::FailureApp
      def recall_app(app)
        controller, action = app.split("#")
        return "Refinery::Memberships::MembersController".constantize.action('login') unless params[:member_login].blank?
        return "#{controller.camelize}Controller".constantize.action(action) if params[:member_login].blank?
      end

      def redirect_url
        if request_format == :html
          if /^admin/.match(params[:controller])
            refinery.send(:"new_#{scope}_session_path")
          else
            refinery.login_members_path(:redirect => env['REQUEST_URI'], :member_login => true)
          end
        else
          refinery.send(:"new_#{scope}_session_path", :format => request_format)
        end
      end

    end
  end
end
