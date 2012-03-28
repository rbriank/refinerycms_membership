class MembersController < ApplicationController

  # Protect these actions behind member login - do we need to check out not signing up when signed in?
  #before_filter :redirect?, :except => [:new, :create, :login, :index, :welcome, :activate]
  before_filter :redirect?, :only => [:profile, :update, :edit]

  before_filter :find_page, :except => [:activate, :login, :create_password, :reset_password, :do_reset_password]

  # GET /member/:id
  def profile
    @member = current_user
  end

  def new
    @member = Member.new
  end

  # GET /members/:id/edit
  def edit
    @member = current_user
  end

  # PUT /members/:id
  def update
    @member = current_user

    if params[:member][:password].blank? and params[:member][:password_confirmation].blank?
      params[:member].delete(:password)
      params[:member].delete(:password_confirmation)
    end

    

    if @member.update_attributes(params[:member])
      flash[:notice] = t('successful', :scope => 'members.update', :email => @member.email)
      MembershipMailer.profile_update_notification_admin(@member).deliver unless is_admin?
      redirect_to profile_members_path

    else
      render :action => 'edit'
    end
  end

  def create
    @member = Member.new(params[:member])

    if @member.save
      MembershipMailer::deliver_member_created(@member)
      
      redirect_to welcome_members_path

    else
      @member.errors.delete(:username) # this is set to email
      render :action => :new
      
    end

  end

  def searching?
    params[:search].present?
  end

	def login
    find_page('/members/login')
	end
	
  def welcome
  end
  
  def activate
    find_page('/members/activate')
    resource = Member.confirm_by_token(params[:confirmation_token])
    
    if resource.errors.present?
      error_404
    end
  end

  def new_password
    @new_password_request = NewPasswordRequest.new 
  end


  def create_password
    @new_password_request = NewPasswordRequest.new(params[:new_password_request])
    if @new_password_request.valid?
      @member = Member::where(:email => params[:new_password_request][:email])[0]
      if @member.present?
        @member.send(:generate_reset_password_token!)
        MembershipMailer.deliver_reset_password(@member)
      end
      redirect_to instructions_sent_members_path
    else
      render :action => :new_password
    end
  end

  def new_password_created
  end

  def instructions_sent
  end

  def reset_password
    find_page('/members/reset_password')
    tok = params[:reset_password_token]
    @member = Member::where(:reset_password_token => tok)[0]
    @password_reset = PasswordReset.new :reset_password_token => tok
    error_404 unless @member.present?
  end

  def do_reset_password
    @password_reset = PasswordReset.new params[:password_reset]
    if @password_reset.valid? 
      @member = Member::where(:reset_password_token => @password_reset.reset_password_token)[0]
      error_404 and return unless @member.present?
      if @member.reset_password!(@password_reset.password, @password_reset.password_confirmation)
        redirect_to reset_done_members_path
        return
      end
    end
    find_page('/members/reset_password')
    render :action => :reset_password
  end

  def reset_done     
  end

  private

protected
  def redirect?
    if current_user.nil?
      redirect_to new_user_session_path
    end
  end

  def find_page(uri = nil)
    uri = uri ? uri : request.fullpath
    uri.gsub!(/\?.*/, '')
    @page = Page.find_by_link_url(uri, :include => [:parts, :slugs])
  end
end
