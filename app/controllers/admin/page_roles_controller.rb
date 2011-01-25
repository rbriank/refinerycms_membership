class Admin::PageRolesController < Admin::MembershipsController
  
  def index
    items = Page.all
    roles = Role.all
    render :partial => 'admin/shared/list', :layout => false,
      :locals => {:kind => 'page', :items => items, 
        :roles => roles, :title_key => :title}
  end

end