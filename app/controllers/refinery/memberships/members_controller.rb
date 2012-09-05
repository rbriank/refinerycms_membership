module Refinery
  module Memberships
    class MembersController < ::ApplicationController
    
      #crudify :'refinery/memberships/member'
      
      # Protect these actions behind member login - do we need to check out not signing up when signed in?
      before_filter :redirect?, :except => [:new, :create]
    
      # GET /member/:id
      def show
        @page = ::Refinery::Page.find_by_link_url('/member_show')
      end
    
      def new
        @member = ::Refinery::Memberships::Member.new
        @page = ::Refinery::Page.find_by_link_url('/members/new')
      end
    
      # GET /members/:id/edit
      def edit
        @member = get_member(params[:id])
        @is_admin = is_admin?
        @page = ::Refinery::Page.find_by_link_url('/member_edit')
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
          ::Refinery::Memberships::MembershipMailer.profile_update_notification_admin(@member).deliver unless is_admin?
          redirect_to_main_path
    
        else
          @is_admin = is_admin?
          @page = ::Refinery::Page.find_by_link_url('/member_edit')
          render :action => 'edit'
        
        end
      end
    
      def create
        @member = ::Refinery::Memberships::Member.new(params[:member])
        @member.username = @member.email
        @member.membership_level = 'Member'
    
        if @member.save
          ::Refinery::Memberships::MembershipMailer.application_confirmation_member(@member).deliver
          ::Refinery::Memberships::MembershipMailer.application_confirmation_admin(@member).deliver
          
          redirect_to_main_path    
        else
          @page = ::Refinery::Page.find_by_link_url('/members/new')
          @member.errors.delete(:username) # this is set to email
          render :action => :new
          
        end
    
      end
    
      def searching?
        params[:search].present?
      end
    
      def index
        respond_to do |format|
          format.html{
            @page = ::Refinery::Page.find_by_link_url('/members')
          }
          format.js{
            @objects = current_objects(params)
            @total_objects = total_objects(params)
            render :layout => false
          }
        end
      end
    
      private
      
      def redirect_to_main_path
        redirect_to(is_admin? ? refinery.memberships_admin_memberships_path : refinery.root_path )
      end
    
      def current_objects(params={})
        current_page = (params[:iDisplayStart].to_i/params[:iDisplayLength].to_i rescue 0)+1
        @current_objects = ::Refinery::Memberships::Member.paginate :page => current_page,
          :include => [:roles],
          :order => "#{datatable_columns(params[:iSortCol_0])} #{params[:sSortDir_0] || "DESC"}",
          :conditions => conditions,
          :per_page => params[:iDisplayLength]
      end
    
      def total_objects(params={})
        all = ::Refinery::Memberships::Member.includes(:roles).where(conditions).count
        admins = ::Refinery::Memberships::Member.includes(:roles).where(:refinery_roles => {:id => [REFINERY_ROLE_ID, SUPERUSER_ROLE_ID]}).count
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
        ::Refinery::Memberships::MembershipMailer.acceptance_confirmation_member(member).deliver
        ::Refinery::Memberships::MembershipMailer.acceptance_confirmation_admin(member, current_refinery_user).deliver
      end
    
      def reject_member(member)
        member.deactivate
        ::Refinery::Memberships::MembershipMailer.rejection_confirmation_member(member).deliver
        ::Refinery::Memberships::MembershipMailer.rejection_confirmation_admin(member, current_refinery_user).deliver
      end
    
    protected
      def redirect?
        if current_refinery_user.nil?
          store_location
          redirect_to refinery.send(Refinery::Memberships.new_user_method_path)
        end
      end
    
      # unless you're an admin, you can only edit your profile
      def get_member(id)
        is_admin? ?  ::Refinery::Memberships::Member.find(id) : current_refinery_user
      end
    
      def is_admin?
        !(current_refinery_user.role_ids & [REFINERY_ROLE_ID, SUPERUSER_ROLE_ID]).empty?
      end
    end
  end
end
