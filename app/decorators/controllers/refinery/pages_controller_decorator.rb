::Refinery::PagesController.class_eval do
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