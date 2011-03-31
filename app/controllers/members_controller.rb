class MembersController < ApplicationController

  # Protect these actions behind member login - do we need to check out not signing up when signed in?
  before_filter :redirect?, :except => [:new, :create, :login, :index, :thank_you]

  before_filter :find_page

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

    # keep these the same
    params[:member][:username] = params[:member][:email]

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
    @member.username = @member.email
    @member.membership_level = 'Member'

    if @member.save
      MembershipMailer.application_confirmation_member(@member).deliver
      MembershipMailer.application_confirmation_admin(@member).deliver
      
      redirect_to thank_you_members_path

    else
      @member.errors.delete(:username) # this is set to email
      render :action => :new
      
    end

  end

  def searching?
    params[:search].present?
  end

	def login
	end
	
  def thank_you
  end

  private

protected
  def redirect?
    if current_user.nil?
      redirect_to new_user_session_path
    end
  end

  def find_page
    uri = request.request_uri
    uri.gsub!(/\?.*/, '')
    @page = Page.find_by_link_url(uri, :include => [:parts, :slugs])
  end
end
