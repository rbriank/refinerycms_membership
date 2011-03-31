class MembersController < ApplicationController

  crudify :member
  
  # Protect these actions behind member login - do we need to check out not signing up when signed in?
  before_filter :redirect?, :except => [:new, :create, :login, :index]

  before_filter :find_page

  # GET /member/:id
  def show
    @page = Page.find_by_link_url('/member_show')
  end

  def new
    @member = Member.new
    @page = Page.find_by_link_url('/members/new')
  end

  # GET /members/:id/edit
  def edit
    @member = get_member(params[:id])
    @is_admin = is_admin?
    @page = Page.find_by_link_url('/member_edit')
  end

  # PUT /members/:id
  def update
    @member = get_member(params[:id])

    if params[:member][:password].blank? and params[:member][:password_confirmation].blank?
      params[:member].delete(:password)
      params[:member].delete(:password_confirmation)
    end

    # approve/reject - admin for non-member only
    if is_admin?
      if params["admin"] && !@member.is_member?
        if params["admin"]["action"] == 'approve'
          accept_member(@member)
        elsif params["admin"]["action"] == 'reject'
          reject_member(@member) unless @member.is_
        end
      end
    end

    params.delete("admin")

    # keep these the same
    params[:member][:username] = params[:member][:email]

    if @member.update_attributes(params[:member])
      flash[:notice] = t('successful', :scope => 'members.update', :email => @member.email)
      MembershipMailer.profile_update_notification_admin(@member).deliver unless is_admin?
      redirect_to(is_admin? ? admin_memberships_path : root_path )

    else
      @is_admin = is_admin?
      @page = Page.find_by_link_url('/member_edit')
      render :action => 'edit'
    
    end
  end

  def create
    @member = Member.new(params[:member])
    @member.username = @member.email
    @member.membership_level = 'Member'

    if @member.save
      MembershipMailer.application_confirmation_member(@member).deliver
      MembershipMailer.application_confirmation_admin(@member).deliver
      
      redirect_to(is_admin? ? admin_memberships_path : root_path )

    else
      @page = Page.find_by_link_url('/members/new')
      @member.errors.delete(:username) # this is set to email
      render :action => :new
      
    end

  end

  def searching?
    params[:search].present?
  end

  def index
    redirect_to login_members_path
  end

	def login
	end

  private

  def current_objects(params={})
    current_page = (params[:iDisplayStart].to_i/params[:iDisplayLength].to_i rescue 0)+1
    @current_objects = Member.paginate :page => current_page,
      :include => [:roles],
      :order => "#{datatable_columns(params[:iSortCol_0])} #{params[:sSortDir_0] || "DESC"}",
      :conditions => conditions,
      :per_page => params[:iDisplayLength]
  end

  def total_objects(params={})
    all = Member.count(:include => [:roles], :conditions => conditions)
    admins = Member.count(:include => :roles, :conditions => "roles.id in (#{REFINERY_ROLE_ID},#{SUPERUSER_ROLE_ID})")
    @total_objects = all - admins
  end

  def datatable_columns(column_id)
    case column_id.to_i
    when 0
      return "last_name"
    when 1
      return "organization"
    when 2
      return "city"
    when 3
      return "province"
    when 4
      return "phone"
    when 5
      return "email"
    end

  end

  def conditions
    conditions = []

    unless params[:sSearch].blank?

      search = []
      %w(first_name last_name organization city province phone email).each{ |field|
        search << "#{field} LIKE '%#{params[:sSearch]}%'"
      }
      conditions << search.join(" OR ")
    end

    return conditions.join(" AND ")
  end

  def accept_member(member)
    member.activate
    MembershipMailer.acceptance_confirmation_member(member).deliver
    MembershipMailer.acceptance_confirmation_admin(member, current_user).deliver
  end

  def reject_member(member)
    member.deactivate
    MembershipMailer.rejection_confirmation_member(member).deliver
    MembershipMailer.rejection_confirmation_admin(member, current_user).deliver
  end

protected
  def redirect?
    if current_user.nil?
      redirect_to new_user_session_path
    end
  end

  # unless you're an admin, you can only edit your profile
  def get_member(id)
    is_admin? ?  Member.find(id) : current_user
  end

  def is_admin?
    !(current_user.role_ids & [REFINERY_ROLE_ID, SUPERUSER_ROLE_ID]).empty?
  end
  
  def find_page
    uri = request.request_uri
    uri.gsub!(/\?.*/, '')
    @page = Page.find_by_link_url(uri, :include => [:parts, :slugs])
  end
end
