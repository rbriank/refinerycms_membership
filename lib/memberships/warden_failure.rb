module Refinery
  module Memberships
    class WardenFailure < Devise::FailureApp
      def recall_app(app)
        controller, action = app.split("#")
        return "MembersController".constantize.action('login') unless params[:member_login].blank?
        return "#{controller.camelize}Controller".constantize.action(action) if params[:member_login].blank?
      end
    end
  end
end
