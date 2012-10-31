Refinery::PagesController.class_eval do
  before_filter :restrict_by_role, :only => :show

  def restrict_by_role
    unless @page.user_allowed?(current_refinery_user)
      redirect_to login_members_path(:redirect => request.fullpath, :member_login => true)
    end
  end

end
