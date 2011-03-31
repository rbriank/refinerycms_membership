module Refinery
  module Memberships
    class WardenFailure < Devise::FailureApp
      def redirect_url
        params[:member_login].present? ? 
          login_members_path(:redirect => params[:redirect]) :
          super
      end

      # You need to override respond to eliminate recall
      def respond
        if http_auth?
          http_auth
        elsif warden_options[:recall] && params[:member_login].blank?
          recall
        else
          redirect
        end
      end
    end
  end
end
