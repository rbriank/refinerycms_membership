module Refinery
  module Memberships
    class WardenFailure < Devise::FailureApp
      def recall_app(app)
        controller, action = app.split("#")
        return "MembersController".constantize.action('login') unless params[:member_login].blank?
        return "#{controller.camelize}Controller".constantize.action(action) if params[:member_login].blank?
      end
      
      def redirect_url
        if request_format == :html 
          if /^admin/.match(params[:controller])
            send(:"new_#{scope}_session_path") 
          else
            login_members_path(:redirect => request.fullpath, :member_login => true)
          end
        else
          send(:"new_#{scope}_session_path", :format => request_format)
        end
      end

    end
  end
end
