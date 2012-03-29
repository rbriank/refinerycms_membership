#redirect user to the right page after login
ApplicationController.class_eval do
  def render(*args)
    Rails.logger.info @page.inspect
    unless @page.nil? || self.class.name == 'PagesController' || self.class.name =~ /^Admin::/
      redirect_to login_members_path(:redirect => request.fullpath, :member_login => true) unless @page.user_allowed?(current_refinery_user)
      super *args if @page.user_allowed?(current_refinery_user)
    else
      super *args
    end
  end

  protected
  def after_sign_in_path_for(resource_or_scope)

    # if resource_or_scope.class.superclass.name == 'User' ||
      # resource_or_scope.class.name == 'User' ||
      # resource_or_scope.to_s == 'user'
    if (resource_or_scope.instance_of?(Refinery::User) || resource_or_scope == :user)
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