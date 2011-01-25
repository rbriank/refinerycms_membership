class Admin::UserRolesController < Admin::MembershipsController

  # GET /refinery/user_roles
  def index
    items = User.all
    roles = Role.all
    render :partial => 'admin/shared/list', :layout => false,
      :locals => {:kind => 'user', :items => items, 
        :roles => roles, :title_key => :email}
  end

end